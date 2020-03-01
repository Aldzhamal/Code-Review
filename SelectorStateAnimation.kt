

import android.content.Context
import android.graphics.drawable.StateListDrawable
import android.view.View
import androidx.core.app.ActivityCompat


class SelectorStateAnimation {

    private val duration: Int = 500

    fun firstViewChangeStateAnimation(context: Context, firstView: View, secondView: View) {
        val stateList = StateListDrawable()
        val buttonFocused = ActivityCompat.getDrawable(context, R.drawable.btn_wish_list_selected)
        val buttonUnSelected = ActivityCompat.getDrawable(context, R.drawable.bg_button_play_selected)
        stateList.setExitFadeDuration(duration)
        stateList.addState(intArrayOf(android.R.attr.state_focused), buttonFocused)
        stateList.addState(intArrayOf(), buttonUnSelected)
        firstView.background = stateList
        firstView.animate().scaleX(1.1f).scaleY(1.1f).setDuration(duration.toLong()).start()
        secondView.animate().scaleX(1.0f).scaleY(1.0f).setDuration(duration.toLong()).start()
    }

    fun secondViewChangeStateAnimation(context: Context, firstView: View, secondView: View) {
        val stateList = StateListDrawable()
        val buttonFocused = ActivityCompat.getDrawable(context, R.drawable.btn_wish_list_selected)
        val buttonUnSelected = ActivityCompat.getDrawable(context, R.drawable.bg_button_play)
        stateList.setExitFadeDuration(duration)
        stateList.addState(intArrayOf(android.R.attr.state_focused), buttonFocused)
        stateList.addState(intArrayOf(), buttonUnSelected)
        firstView.background = stateList
        firstView.animate().scaleX(1.1f).scaleY(1.1f).setDuration(duration.toLong()).start()
        secondView.animate().scaleX(1.0f).scaleY(1.0f).setDuration(duration.toLong()).start()
    }

}