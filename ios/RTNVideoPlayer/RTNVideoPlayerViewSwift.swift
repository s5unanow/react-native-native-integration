import AVFoundation
import UIKit

@objc(RTNVideoPlayerViewSwift)
class RTNVideoPlayerViewSwift: UIView {
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var progressObserver: Any?
  private var endObserver: NSObjectProtocol?
  private var hasEnded = false

  @objc var onVideoProgress: (([String: Any]) -> Void)?
  @objc var onVideoEnd: (([String: Any]) -> Void)?

  @objc var sourceUrl: NSString = "" {
    didSet {
      configurePlayer()
    }
  }

  @objc var paused: Bool = false {
    didSet {
      applyPlaybackState()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    cleanupPlayer()
  }

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
    paused = true
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
    playerLayer?.frame = bounds
  }
}
