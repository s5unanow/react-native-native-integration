package com.reactnativenativeintegration.videoplayer

import android.content.Context
import android.graphics.Color
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

    private val playerView =
        PlayerView(context).apply {
            layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        }

    private var player: ExoPlayer? = null
    private var currentUrl: String? = null
    private var isPaused: Boolean = false
    private val progressHandler = Handler(Looper.getMainLooper())
    private var progressRunnable: Runnable? = null
    private var hasEnded: Boolean = false

    init {
        addView(playerView)
        setBackgroundColor(Color.BLACK)
    }

    fun setSourceUrl(url: String?) {
        if (url == currentUrl) {
            return
        }

        currentUrl = url
        hasEnded = false

        if (url.isNullOrBlank()) {
            release()
            return
        }

        setupPlayer(url)
    }

    fun setPaused(paused: Boolean) {
        isPaused = paused

        if (paused || hasEnded) {
            player?.playWhenReady = false
            stopProgressReporting()
        } else {
            player?.playWhenReady = true
            startProgressReporting()
        }
    }

    fun release() {
        stopProgressReporting()
        playerView.player = null
        player?.release()
        player = null
        hasEnded = false
    }

    private fun setupPlayer(url: String) {
        release()
        hasEnded = false

        player =
            ExoPlayer.Builder(context).build().apply {
                playerView.player = this
                setMediaItem(MediaItem.fromUri(url))
                prepare()
                playWhenReady = !isPaused

                addListener(
                    object : Player.Listener {
                        override fun onPlaybackStateChanged(playbackState: Int) {
                            if (playbackState == Player.STATE_ENDED) {
                                handlePlaybackEnded()
                            }
                        }
                    },
                )
            }

        if (!isPaused) {
            startProgressReporting()
        }
    }

    private fun startProgressReporting() {
        stopProgressReporting()

        if (hasEnded) {
            return
        }

        progressRunnable =
            object : Runnable {
                override fun run() {
                    emitProgressEvent()
                    progressHandler.postDelayed(this, 500)
                }
            }

        progressHandler.post(progressRunnable!!)
    }

    private fun stopProgressReporting() {
        progressRunnable?.let(progressHandler::removeCallbacks)
        progressRunnable = null
    }

    private fun handlePlaybackEnded() {
        if (hasEnded) {
            return
        }

        hasEnded = true
        player?.playWhenReady = false
        stopProgressReporting()
        emitProgressEvent()
        emitVideoEndEvent()
    }

    private fun emitProgressEvent() {
        val player = player ?: return
        val duration = player.duration.takeIf { it > 0 } ?: return
        val currentTime = player.currentPosition.coerceIn(0, duration)
        val progress = currentTime.toDouble() / duration.toDouble()
        val reactContext = context as? ReactContext ?: return
        val eventDispatcher = UIManagerHelper.getEventDispatcher(reactContext)

        eventDispatcher?.dispatchEvent(
            VideoProgressEvent(
                UIManagerHelper.getSurfaceId(reactContext),
                id,
                currentTime / 1000.0,
                duration / 1000.0,
                progress.coerceIn(0.0, 1.0),
            ),
        )
    }

    private fun emitVideoEndEvent() {
        val reactContext = context as? ReactContext ?: return
        val eventDispatcher = UIManagerHelper.getEventDispatcher(reactContext)

        eventDispatcher?.dispatchEvent(
            VideoEndEvent(
                UIManagerHelper.getSurfaceId(reactContext),
                id,
            ),
        )
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        release()
    }

    private class VideoProgressEvent(
        surfaceId: Int,
        viewId: Int,
        private val currentTime: Double,
        private val duration: Double,
        private val progress: Double,
    ) : Event<VideoProgressEvent>(surfaceId, viewId) {
        override fun getEventName(): String = "topVideoProgress"

        override fun getEventData() =
            Arguments.createMap().apply {
                putDouble("currentTime", currentTime)
                putDouble("duration", duration)
                putDouble("progress", progress)
            }
    }

    private class VideoEndEvent(
        surfaceId: Int,
        viewId: Int,
    ) : Event<VideoEndEvent>(surfaceId, viewId) {
        override fun getEventName(): String = "topVideoEnd"

        override fun getEventData() = Arguments.createMap()
    }
}
