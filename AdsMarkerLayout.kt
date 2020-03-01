

import android.content.Context
import android.util.AttributeSet
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.RelativeLayout
import java.text.SimpleDateFormat
import java.util.*


class AdsMarkerLayout(context: Context, attrs: AttributeSet? = null) : FrameLayout(context, attrs) {

    private val params = RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT)
    private lateinit var adsMarkerView: AdsMarkerView
    private var seekWidth = 0
    private var seekMax = 0

    init {
        id = R.id.ads_marker_layout
        params.addRule(RelativeLayout.CENTER_IN_PARENT)
        layoutParams = params
    }

    internal fun setAdsMarkerLayoutWidthAndSeekWidth(seekWidth: Int, seekMax: Int) {
        this.seekWidth = seekWidth
        this.seekMax = seekMax
        params.width = seekWidth
        layoutParams = params
        invalidate()
    }

    internal fun addAdsMarkers(adBreaks: List<String>) {
        removeAllViews()
        for (markers in adBreaks) {
            adsMarkerView = AdsMarkerView(context)
            addView(adsMarkerView)
            adsMarkerView.setMarkerPosition(getPosition(markers))
        }
        invalidate()
    }

    //NOTE: convert time marker to x coordinate
    private fun getPosition(time: String): Float {

        val cal = Calendar.getInstance()
        val date = SimpleDateFormat("hh:mm:ss", Locale.getDefault())
        cal.time = date.parse(time)
        cal.set(1970, 0, 1)

        val hours = cal.get(Calendar.HOUR) * 60
        val minutes = cal.get(Calendar.MINUTE)
        val seconds = cal.get(Calendar.SECOND).toFloat() / 60
        val timeMarker: Float = (hours + minutes + seconds) * 60

        return this.seekWidth * timeMarker / this.seekMax
    }
}