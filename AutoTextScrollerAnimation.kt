

import android.view.animation.Animation
import android.view.animation.LinearInterpolator
import android.view.animation.TranslateAnimation
import android.widget.TextView

class AutoTextScrollerAnimation(private var text: TextView, length: Float, duration: Long) {

    var animator: Animation = TranslateAnimation(
            Animation.RELATIVE_TO_SELF, 0.01f,
            Animation.RELATIVE_TO_SELF, length,
            Animation.RELATIVE_TO_SELF, 0f,
            Animation.RELATIVE_TO_SELF, 0f
    )

    init {
        this.animator.interpolator = LinearInterpolator()
        this.animator.duration = duration
        this.animator.fillAfter = true
        this.animator.repeatMode = Animation.REVERSE
        this.animator.repeatCount = Animation.INFINITE

    }

    fun start() {
        this.text.isSelected = true
        this.text.startAnimation(this.animator)

    }

    fun clearAnimation() {
        this.text.clearAnimation()
    }

}