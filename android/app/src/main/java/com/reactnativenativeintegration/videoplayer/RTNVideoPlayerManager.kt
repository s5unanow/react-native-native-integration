package com.reactnativenativeintegration.videoplayer

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.RTNVideoPlayerManagerInterface
import com.facebook.react.viewmanagers.RTNVideoPlayerManagerDelegate

@ReactModule(name = RTNVideoPlayerManager.NAME)
class RTNVideoPlayerManager : SimpleViewManager<RTNVideoPlayerView>(),
    RTNVideoPlayerManagerInterface<RTNVideoPlayerView> {

    private val delegate = RTNVideoPlayerManagerDelegate(this)

    override fun getDelegate(): ViewManagerDelegate<RTNVideoPlayerView> = delegate

    override fun getName(): String = NAME

    override fun createViewInstance(context: ThemedReactContext): RTNVideoPlayerView {
        return RTNVideoPlayerView(context)
    }

    @ReactProp(name = "sourceUrl")
    override fun setSourceUrl(view: RTNVideoPlayerView, sourceUrl: String?) {
        view.setSourceUrl(sourceUrl)
    }

    @ReactProp(name = "paused")
    override fun setPaused(view: RTNVideoPlayerView, paused: Boolean) {
        view.setPaused(paused)
    }

    companion object {
        const val NAME = "RTNVideoPlayer"
    }
}
