package com.reactnativenativeintegration.videoplayer

import android.content.Context
import android.widget.FrameLayout
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView

@OptIn(UnstableApi::class)
class RTNVideoPlayerView(context: Context) : FrameLayout(context) {

    private var player: ExoPlayer? = null
    private var playerView: PlayerView
    private var currentUrl: String? = null
    private var isPaused: Boolean = false

    init {
        playerView = PlayerView(context).apply {
            layoutParams = LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT
            )
        }
        addView(playerView)
        setBackgroundColor(android.graphics.Color.BLACK)
    }

    fun setSourceUrl(url: String?) {
        if (url == currentUrl) return
        currentUrl = url

        url?.let { setupPlayer(it) }
    }

    fun setPaused(paused: Boolean) {
        isPaused = paused
        player?.playWhenReady = !paused
    }

    private fun setupPlayer(url: String) {
        releasePlayer()

        player = ExoPlayer.Builder(context).build().apply {
            playerView.player = this
            setMediaItem(MediaItem.fromUri(url))
            prepare()
            playWhenReady = !isPaused
        }
    }

    private fun releasePlayer() {
        player?.release()
        player = null
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        releasePlayer()
    }
}
