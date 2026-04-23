import AVFoundation
import UIKit

// Fabric related: This UIView is exposed to Objective-C++ through the generated
// ReactNativeNativeIntegration-Swift.h header. The Fabric adapter owns the
// React Native lifecycle; this class owns the platform playback details.
@objc(RTNVideoPlayerViewSwift)
class RTNVideoPlayerViewSwift: UIView {
  // Implementation detail: AVPlayer does playback, while AVPlayerLayer renders
  // the video frames inside this UIView's Core Animation layer tree.
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  // Implementation detail: These observers drive progress and end events for
  // the demo player implementation.
  private var progressObserver: Any?
  private var endObserver: NSObjectProtocol?
  private var hasEnded = false

  // Fabric related: Objective-C++ assigns these closures and forwards them to
  // the generated Fabric event emitter.
  @objc var onVideoProgress: (([String: Any]) -> Void)?
  @objc var onVideoEnd: (([String: Any]) -> Void)?

  // Fabric related: Objective-C++ writes this prop when Fabric receives a new
  // sourceUrl from JS.
  // Implementation detail: Rebuilding the player keeps the native state aligned
  // with the React prop.
  @objc var sourceUrl: NSString = "" {
    didSet {
      configurePlayer()
    }
  }

  // Fabric related: Objective-C++ writes this prop when Fabric receives paused
  // from JS.
  // Implementation detail: The Swift view turns that declarative prop into
  // imperative AVPlayer calls.
  @objc var paused: Bool = false {
    didSet {
      applyPlaybackState()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black
  }

  // Implementation detail: Standard UIView boilerplate, not Fabric-specific.
  // The view is built programmatically by the Fabric adapter, never decoded from
  // a storyboard.
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Implementation detail: Final safety net. Fabric should normally call reset
  // through the adapter lifecycle before release; without this, an orphaned
  // AVPlayer could keep audio playing after the view is gone.
  deinit {
    cleanupPlayer()
  }

  // Fabric related: Called by the Fabric adapter when the component is recycled
  // or invalidated. It returns the Swift view to the same neutral state as a
  // fresh instance.
  @objc func reset() {
    cleanupPlayer()
    sourceUrl = ""
    paused = false
  }

  @objc func play() {
    paused = false

    guard !hasEnded else {
      return
    }

    player?.play()
    startProgressReporting()
  }

  @objc func pause() {
    paused = true
    player?.pause()
    stopProgressReporting()
  }

  @objc func seekTo(_ time: Double) {
    guard let player else {
      return
    }

    let duration = CMTimeGetSeconds(player.currentItem?.duration ?? .invalid)
    let targetTime = time.isFinite ? max(0, time) : 0
    let boundedTime = duration.isFinite && duration > 0 ? min(targetTime, duration) : targetTime
    let seeksToEnd = duration.isFinite && duration > 0 && boundedTime >= duration

    if !seeksToEnd {
      hasEnded = false
    }

    player.seek(to: CMTime(seconds: boundedTime, preferredTimescale: 1000)) {
      [weak self] _ in
      DispatchQueue.main.async {
        guard let self else {
          return
        }

        if seeksToEnd {
          self.handlePlaybackEnded()
        } else {
          self.sendProgressEvent()
          self.applyPlaybackState()
        }
      }
    }
  }

  private func configurePlayer() {
    // Implementation detail: A source change replaces the whole AVPlayer
    // pipeline. This avoids keeping old items, layers, or playback state
    // attached to a reused Fabric view.
    cleanupPlayer()
    hasEnded = false

    let urlString = (sourceUrl as String).trimmingCharacters(in: .whitespacesAndNewlines)
    guard !urlString.isEmpty, let url = URL(string: urlString) else {
      return
    }

    let nextPlayer = AVPlayer(url: url)
    let nextPlayerLayer = AVPlayerLayer(player: nextPlayer)
    nextPlayerLayer.videoGravity = .resizeAspect
    nextPlayerLayer.frame = bounds

    layer.addSublayer(nextPlayerLayer)
    player = nextPlayer
    playerLayer = nextPlayerLayer

    endObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nextPlayer.currentItem,
      queue: .main
    ) { [weak self] _ in
      // Implementation detail: AVFoundation reports the native player ending;
      // the Swift view converts that into the tutorial event payload.
      self?.handlePlaybackEnded()
    }

    applyPlaybackState()
  }

  private func applyPlaybackState() {
    // Implementation detail: The React prop is declarative, but AVPlayer is
    // imperative. This method is the small translation point between those two
    // models.
    if paused {
      player?.pause()
      stopProgressReporting()
    } else {
      guard !hasEnded else {
        return
      }

      player?.play()
      startProgressReporting()
    }
  }

  private func cleanupPlayer() {
    // Implementation detail: Stop playback and remove the rendering layer so a
    // recycled view cannot keep playing or displaying stale video content.
    stopProgressReporting()

    if let endObserver {
      NotificationCenter.default.removeObserver(endObserver)
      self.endObserver = nil
    }

    player?.pause()
    playerLayer?.removeFromSuperlayer()
    playerLayer = nil
    player = nil
    hasEnded = false
  }

  private func startProgressReporting() {
    // Implementation detail: A periodic AVPlayer observer produces the
    // onVideoProgress event data while playback is active.
    guard progressObserver == nil, let player else {
      return
    }

    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    progressObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
      [weak self] _ in
      self?.sendProgressEvent()
    }
  }

  private func stopProgressReporting() {
    // Implementation detail: Removing the observer prevents duplicate progress
    // callbacks after pause, cleanup, or view reuse.
    guard let progressObserver, let player else {
      self.progressObserver = nil
      return
    }

    player.removeTimeObserver(progressObserver)
    self.progressObserver = nil
  }

  private func handlePlaybackEnded() {
    // Implementation detail: Send one final progress event, then the end event,
    // and guard so completion is reported only once per source.
    guard !hasEnded else {
      return
    }

    hasEnded = true
    paused = true
    player?.pause()
    stopProgressReporting()
    sendProgressEvent()
    onVideoEnd?([:])
  }

  private func sendProgressEvent() {
    // Implementation detail: Convert AVPlayer time values into the JS event
    // payload shape from the native component spec.
    guard let player, let currentItem = player.currentItem else {
      return
    }

    let currentTime = CMTimeGetSeconds(player.currentTime())
    let duration = CMTimeGetSeconds(currentItem.duration)

    guard currentTime.isFinite, duration.isFinite, duration > 0 else {
      return
    }

    let reportedCurrentTime = min(max(currentTime, 0), duration)

    onVideoProgress?([
      "currentTime": reportedCurrentTime,
      "duration": duration,
      "progress": reportedCurrentTime / duration,
    ])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    // Implementation detail: React Native controls the UIView bounds. Keep the
    // AVPlayerLayer in sync whenever layout changes.
    playerLayer?.frame = bounds
  }
}
