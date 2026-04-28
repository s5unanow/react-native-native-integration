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
    // Implementation detail: Handler-based polling drives progress events while
    // ExoPlayer is actively playing.
    private val progressHandler = Handler(Looper.getMainLooper())
    private var progressRunnable: Runnable? = null
    private var hasEnded: Boolean = false

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
        hasEnded = false

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

        if (paused || hasEnded) {
            player?.playWhenReady = false
            stopProgressReporting()
        } else {
            player?.playWhenReady = true
            startProgressReporting()
        }
    }

    fun playPlayback() {
        // Implementation detail: Command playback uses the same isPaused state
        // as the React prop before starting ExoPlayer.
        isPaused = false

        if (hasEnded) {
            return
        }

        player?.playWhenReady = true
        startProgressReporting()
    }

    fun pausePlayback() {
        // Implementation detail: Pause command mirrors the paused prop behavior
        // and stops progress callbacks.
        isPaused = true
        player?.playWhenReady = false
        stopProgressReporting()
    }

    fun seekTo(time: Double) {
        // Implementation detail: Convert command seconds to ExoPlayer
        // milliseconds, clamp to duration, and keep progress/end state aligned.
        val player = player ?: return
        val duration = player.duration.takeIf { it > 0 }
        val targetPosition = (time.takeIf { it.isFinite() } ?: 0.0)
            .coerceAtLeast(0.0)
            .times(1000)
            .toLong()
        val boundedPosition = duration?.let { targetPosition.coerceAtMost(it) } ?: targetPosition
        val seeksToEnd = duration != null && boundedPosition >= duration

        if (!seeksToEnd) {
            hasEnded = false
        }

        player.seekTo(boundedPosition)

        if (seeksToEnd) {
            handlePlaybackEnded()
        } else {
            emitProgressEvent()

            if (isPaused || hasEnded) {
                player.playWhenReady = false
                stopProgressReporting()
            } else {
                player.playWhenReady = true
                startProgressReporting()
            }
        }
    }

    fun release() {
        // Implementation detail: Detach and release ExoPlayer so recycled or
        // removed native views cannot keep playing media.
        stopProgressReporting()
        playerView.player = null
        player?.release()
        player = null
        hasEnded = false
    }

    private fun setupPlayer(url: String) {
        // Implementation detail: A source change replaces the whole ExoPlayer
        // pipeline to avoid stale media state on reused native views.
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
                            // Implementation detail: ExoPlayer reports the
                            // native end state; this view emits the tutorial
                            // end event once.
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
        // Implementation detail: Poll every 500 ms to keep the JS progress
        // event updated during playback.
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
        // Implementation detail: Remove the pending callback so paused,
        // released, or recycled views stop emitting progress.
        progressRunnable?.let(progressHandler::removeCallbacks)
        progressRunnable = null
    }

    private fun handlePlaybackEnded() {
        // Implementation detail: Report completion once, including one final
        // progress event before onVideoEnd.
        if (hasEnded) {
            return
        }

        hasEnded = true
        isPaused = true
        player?.playWhenReady = false
        stopProgressReporting()
        emitProgressEvent()
        emitVideoEndEvent()
    }

    private fun emitProgressEvent() {
        // Fabric related: Dispatch a direct event through React Native's event
        // dispatcher using the generated surface and view ids.
        // Implementation detail: Convert ExoPlayer milliseconds to the seconds
        // payload expected by JS.
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
        // Fabric related: Dispatch the direct onVideoEnd event for this native
        // view instance.
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
        // Implementation detail: Detach is the final Android view lifecycle
        // cleanup path if React Native removal did not release first.
        release()
    }

    private class VideoProgressEvent(
        surfaceId: Int,
        viewId: Int,
        private val currentTime: Double,
        private val duration: Double,
        private val progress: Double,
    ) : Event<VideoProgressEvent>(surfaceId, viewId) {
        // Fabric related: This native event name must match the exported direct
        // event name registered by the manager.
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
        // Fabric related: This native event name must match the exported direct
        // event name registered by the manager.
        override fun getEventName(): String = "topVideoEnd"

        override fun getEventData() = Arguments.createMap()
    }
}
