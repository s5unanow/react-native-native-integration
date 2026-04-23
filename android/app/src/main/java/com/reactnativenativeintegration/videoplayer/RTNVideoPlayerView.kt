package com.reactnativenativeintegration.videoplayer

import android.content.Context
import android.graphics.Color
import android.widget.FrameLayout
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView

@OptIn(UnstableApi::class)
class RTNVideoPlayerView(context: Context) : FrameLayout(context) {

    private val playerView =
        PlayerView(context).apply {
            layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        }

    private var player: ExoPlayer? = null
    private var currentUrl: String? = null
    private var isPaused: Boolean = false

    init {
        addView(playerView)
        setBackgroundColor(Color.BLACK)
    }

    fun setSourceUrl(url: String?) {
        if (url == currentUrl) {
            return
        }

        currentUrl = url

        if (url.isNullOrBlank()) {
            release()
            return
        }

        setupPlayer(url)
    }

    fun setPaused(paused: Boolean) {
        isPaused = paused
        player?.playWhenReady = !paused
    }

    fun release() {
        playerView.player = null
        player?.release()
        player = null
    }

    private fun setupPlayer(url: String) {
        release()

        player =
            ExoPlayer.Builder(context).build().apply {
                playerView.player = this
                setMediaItem(MediaItem.fromUri(url))
                prepare()
                playWhenReady = !isPaused
            }
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        release()
    }
}
