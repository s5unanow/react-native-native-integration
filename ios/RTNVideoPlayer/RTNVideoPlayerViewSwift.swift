import AVFoundation
import UIKit

@objc(RTNVideoPlayerViewSwift)
class RTNVideoPlayerViewSwift: UIView {
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?

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

  private func configurePlayer() {
    cleanupPlayer()

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

    applyPlaybackState()
  }

  private func applyPlaybackState() {
    if paused {
      player?.pause()
    } else {
      player?.play()
    }
  }

  private func cleanupPlayer() {
    player?.pause()
    playerLayer?.removeFromSuperlayer()
    playerLayer = nil
    player = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer?.frame = bounds
  }
}
