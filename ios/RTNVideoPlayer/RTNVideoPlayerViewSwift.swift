import UIKit
import AVKit

@objc(RTNVideoPlayerViewSwift)
class RTNVideoPlayerViewSwift: UIView {

    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    @objc var sourceUrl: NSString = "" {
        didSet {
            setupPlayer()
        }
    }

    @objc var paused: Bool = false {
        didSet {
            paused ? player?.pause() : player?.play()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer() {
        guard let url = URL(string: sourceUrl as String) else { return }

        player?.pause()
        playerLayer?.removeFromSuperlayer()

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = bounds

        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }

        if !paused {
            player?.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
