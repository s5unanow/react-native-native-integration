package com.reactnativenativeintegration.videoplayer

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.RTNVideoPlayerManagerDelegate
import com.facebook.react.viewmanagers.RTNVideoPlayerManagerInterface

// Fabric related: This manager is the Android entry point generated code uses
// to create and update RTNVideoPlayer native views.
@ReactModule(name = RTNVideoPlayerManager.NAME)
class RTNVideoPlayerManager :
    SimpleViewManager<RTNVideoPlayerView>(),
    RTNVideoPlayerManagerInterface<RTNVideoPlayerView> {

    // Fabric related: The generated delegate routes typed prop updates from
    // React Native to the manager methods below.
    private val delegate = RTNVideoPlayerManagerDelegate(this)

    override fun getDelegate(): ViewManagerDelegate<RTNVideoPlayerView> = delegate

    // Fabric related: This name must match the JS native component name.
    override fun getName(): String = NAME

    // Fabric related: React Native calls this when it needs a platform view for
    // the generated component.
    override fun createViewInstance(context: ThemedReactContext): RTNVideoPlayerView {
        return RTNVideoPlayerView(context)
    }

    // Fabric related: Codegen exposes sourceUrl as a typed prop setter.
    @ReactProp(name = "sourceUrl")
    override fun setSourceUrl(view: RTNVideoPlayerView, sourceUrl: String?) {
        view.setSourceUrl(sourceUrl)
    }

    // Fabric related: Codegen exposes paused as a typed prop setter.
    @ReactProp(name = "paused")
    override fun setPaused(view: RTNVideoPlayerView, paused: Boolean) {
        view.setPaused(paused)
    }

    // Fabric related: React Native calls this when the native view is removed.
    // Implementation detail: Releasing here prevents ExoPlayer from continuing
    // playback after the component is gone.
    override fun onDropViewInstance(view: RTNVideoPlayerView) {
        view.release()
        super.onDropViewInstance(view)
    }

    companion object {
        const val NAME = "RTNVideoPlayer"
    }
}
