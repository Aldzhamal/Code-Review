

import android.content.Context
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat



class AdsMarkerView(context: Context) : View(context) {

    init {
        val params = ViewGroup.LayoutParams(5, 7)
        layoutParams = params
        setBackgroundColor(ContextCompat.getColor(context, R.color.white))
    }

    internal fun setMarkerPosition(position: Float) {
        x = position
        invalidate()
    }

}