package com.reactnativenativeintegration.videoplayer

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.widget.FrameLayout
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.events.Event

@OptIn(UnstableApi::class)
class RTNVideoPlayerView(context: Context) : FrameLayout(context) {

    private var player: ExoPlayer? = null
    private var playerView: PlayerView
    private var currentUrl: String? = null
    private var isPaused: Boolean = false
    private val handler = Handler(Looper.getMainLooper())
    private var progressRunnable: Runnable? = null

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
        updateProgressReporting()
    }

    private fun setupPlayer(url: String) {
        releasePlayer()

        player = ExoPlayer.Builder(context).build().apply {
            playerView.player = this
            setMediaItem(MediaItem.fromUri(url))
            prepare()
            playWhenReady = !isPaused

            addListener(object : Player.Listener {
                override fun onPlaybackStateChanged(playbackState: Int) {
                    if (playbackState == Player.STATE_ENDED) {
                        this@RTNVideoPlayerView.commandPause()
                        emitProgressEvent()
                        emitVideoEndEvent()
                    }
                }
            })
        }

        updateProgressReporting()
    }

    private fun updateProgressReporting() {
        progressRunnable?.let { handler.removeCallbacks(it) }
        progressRunnable = null

        if (!isPaused) {
            progressRunnable = object : Runnable {
                override fun run() {
                    emitProgressEvent()
                    handler.postDelayed(this, 500)
                }
            }
            handler.post(progressRunnable!!)
        }
    }

    private fun emitProgressEvent() {
        val player = player ?: return
        val duration = player.duration.takeIf { it > 0 } ?: return
        val currentTime = player.currentPosition
        val progress = currentTime.toDouble() / duration.toDouble()

        val reactContext = context as? ReactContext ?: return
        val eventDispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, id)

        eventDispatcher?.dispatchEvent(
            VideoProgressEvent(
                UIManagerHelper.getSurfaceId(reactContext),
                id,
                currentTime / 1000.0,
                duration / 1000.0,
                progress
            )
        )
    }

    private fun emitVideoEndEvent() {
        val reactContext = context as? ReactContext ?: return
        val eventDispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, id)

        eventDispatcher?.dispatchEvent(
            VideoEndEvent(
                UIManagerHelper.getSurfaceId(reactContext),
                id
            )
        )
    }

    private fun releasePlayer() {
        progressRunnable?.let { handler.removeCallbacks(it) }
        progressRunnable = null
        player?.release()
        player = null
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        releasePlayer()
    }

    // Event classes
    class VideoProgressEvent(
        surfaceId: Int,
        viewId: Int,
        private val currentTime: Double,
        private val duration: Double,
        private val progress: Double
    ) : Event<VideoProgressEvent>(surfaceId, viewId) {

        override fun getEventName() = "topVideoProgress"

        override fun getEventData() = Arguments.createMap().apply {
            putDouble("currentTime", currentTime)
            putDouble("duration", duration)
            putDouble("progress", progress)
        }
    }

    class VideoEndEvent(
        surfaceId: Int,
        viewId: Int
    ) : Event<VideoEndEvent>(surfaceId, viewId) {

        override fun getEventName() = "topVideoEnd"

        override fun getEventData() = Arguments.createMap()
    }
}
