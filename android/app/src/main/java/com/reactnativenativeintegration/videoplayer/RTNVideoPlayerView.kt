package com.reactnativenativeintegration.videoplayer

import android.content.Context
import android.graphics.Color
import android.widget.FrameLayout
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView

// Implementation detail: This view owns the Android playback implementation.
// The manager owns the React Native/Fabric binding.
@OptIn(UnstableApi::class)
class RTNVideoPlayerView(context: Context) : FrameLayout(context) {

    // Implementation detail: PlayerView renders frames from ExoPlayer inside
    // the React Native-managed view bounds.
    private val playerView =
        PlayerView(context).apply {
            useController = false
            layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        }

    // Implementation detail: ExoPlayer handles playback while currentUrl and
    // isPaused keep native state aligned with React props.
    private var player: ExoPlayer? = null
    private var currentUrl: String? = null
    private var isPaused: Boolean = false

    init {
        addView(playerView)
        setBackgroundColor(Color.BLACK)
    }

    fun setSourceUrl(url: String?) {
        // Implementation detail: Ignore duplicate URLs so the player is not
        // rebuilt for an unchanged React prop value.
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
        // Implementation detail: paused is declarative in React, while
        // ExoPlayer uses imperative playWhenReady state.
        isPaused = paused
        player?.playWhenReady = !paused
    }

    fun release() {
        // Implementation detail: Detach and release ExoPlayer so recycled or
        // removed native views cannot keep playing media.
        playerView.player = null
        player?.release()
        player = null
    }

    private fun setupPlayer(url: String) {
        // Implementation detail: A source change replaces the whole ExoPlayer
        // pipeline to avoid stale media state on reused native views.
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
        // Implementation detail: Detach is the final Android view lifecycle
        // cleanup path if React Native removal did not release first.
        release()
    }
}
