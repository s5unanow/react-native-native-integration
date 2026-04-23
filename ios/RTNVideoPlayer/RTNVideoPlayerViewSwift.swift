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
  private var progressObserver: Any?
  private var endObserver: NSObjectProtocol?
  private var hasEnded = false

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
    guard let progressObserver, let player else {
      self.progressObserver = nil
      return
    }

    player.removeTimeObserver(progressObserver)
    self.progressObserver = nil
  }

  private func handlePlaybackEnded() {
    guard !hasEnded else {
      return
    }

    hasEnded = true
    player?.pause()
    stopProgressReporting()
    sendProgressEvent()
    onVideoEnd?([:])
  }

  private func sendProgressEvent() {
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
