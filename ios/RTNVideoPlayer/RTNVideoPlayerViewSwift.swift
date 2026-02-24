import UIKit
import AVKit

@objc(RTNVideoPlayerViewSwift)
class RTNVideoPlayerViewSwift: UIView {

    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var progressTimer: Timer?
    private var playerItemObserver: NSObjectProtocol?

    // Event callbacks
    @objc var onVideoProgress: (([String: Any]) -> Void)?
    @objc var onVideoEnd: (([String: Any]) -> Void)?

    @objc var sourceUrl: NSString = "" {
        didSet {
            setupPlayer()
        }
    }

    @objc var paused: Bool = false {
        didSet {
            paused ? player?.pause() : player?.play()
            updateProgressTimer()
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
        cleanup()
    }

    private func cleanup() {
        progressTimer?.invalidate()
        progressTimer = nil
        if let observer = playerItemObserver {
            NotificationCenter.default.removeObserver(observer)
            playerItemObserver = nil
        }
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }

    private func setupPlayer() {
        guard let url = URL(string: sourceUrl as String) else { return }

        cleanup()

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = bounds

        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }

        // Observe video end
        if let playerItem = player?.currentItem {
            playerItemObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: playerItem,
                queue: .main
            ) { [weak self] _ in
                self?.pause()
                self?.sendProgressEvent()
                self?.onVideoEnd?([:])
            }
        }

        if !paused {
            player?.play()
        }

        updateProgressTimer()
    }

    private func updateProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil

        if !paused {
            progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.sendProgressEvent()
            }
        }
    }

    private func sendProgressEvent() {
        guard let player = player,
              let currentItem = player.currentItem else { return }

        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(currentItem.duration)

        guard currentTime.isFinite && duration.isFinite && duration > 0 else { return }

        let progress = currentTime / duration

        onVideoProgress?([
            "currentTime": currentTime,
            "duration": duration,
            "progress": progress
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
