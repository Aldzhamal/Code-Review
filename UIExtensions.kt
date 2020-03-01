

import android.animation.ValueAnimator
import android.util.Log
import android.view.View
import com.daimajia.androidanimations.library.Techniques
import com.daimajia.androidanimations.library.YoYo


fun View?.gone(duration: Long = 500, endAction: (() -> Unit)? = null) {
    this?.apply {
        alpha = 1f
        animate().alpha(0f).setDuration(duration).setStartDelay(0).withEndAction {
            visibility = View.GONE
            endAction?.invoke()
        }.start()
    }
}

fun View?.invisible(duration: Long = 500, endAction: (() -> Unit)? = null) {
    this?.apply {
        alpha = 1f
        animate().alpha(0f).setDuration(duration).setStartDelay(0).withEndAction {
            visibility = View.INVISIBLE
            endAction?.invoke()
        }.start()
    }
}

fun View?.show(duration: Long = 500, endAction: (() -> Unit)? = null) {
    this?.apply {
        alpha = 0f
        animate().alpha(1f).setDuration(duration).setStartDelay(0).withEndAction {
            endAction?.invoke()
            visibility = View.VISIBLE
        }.start()
    }
}

fun View?.showInfo(endAction: (() -> Unit)? = null) {
    this?.apply {
        visibility = View.VISIBLE
        YoYo.with(Techniques.FadeIn).duration(1000).onEnd {
            endAction?.invoke()
        }.playOn(this)
    }
}

fun MovieInfoView?.updateMovie(layout_new: View?) {
    this?.also {
        if (it.alpha == 0f) {
            it.showInRight()
//            layout_new?.hideToRight()
        } else {
//            it.hideToRight()
            layout_new?.showInRight()
        }
    }
}

fun View?.hideToRight() {
    this?.apply {
        animate().alpha(0f).translationX(120f).setDuration(500).start()
    }
}

fun View?.showInRight() {
    this?.apply {
        val transX = (this.width - 200).toFloat()
        translationX = -transX
        animate().alpha(1f).translationX(0f).setDuration(300).start()
    }
}

fun View?.showDetails(height: Int) {
    fadeIn(700)
    this?.let {
        visibility = View.VISIBLE
        val va = ValueAnimator.ofInt(0, height)
        va.duration = 300
        va.addUpdateListener { animation ->
            val value = animation.animatedValue as Int
            it.layoutParams.height = value
            it.requestLayout()
        }
        va.start()
    }
}

fun View?.hideDetails(height: Int) {
    fadeout(100)
//    this?.let {
//        val va = ValueAnimator.ofInt(height, 0)
//        va.duration = 300
//        va.addUpdateListener { animation ->
//            val value = animation.animatedValue as Int
//            it.layoutParams.height = value
//            it.requestLayout()
//        }
//        va.start()
//    }
    this?.visibility = View.GONE
}

fun View?.showKeyframe() {
    this?.apply {
        alpha = 0f
        visibility = View.VISIBLE
        animate().scaleY(1f).setDuration(300).start()
    }
}


fun View?.showMenu(endAction: (() -> Unit)? = null) {
    this?.apply {
        visibility = View.VISIBLE
        YoYo.with(Techniques.SlideInLeft).duration(300).onEnd {
            endAction?.invoke()
        }.playOn(this)
    }
}

fun View?.hideMenu(endAction: (() -> Unit)? = null) {
    this?.apply {
        YoYo.with(Techniques.SlideOutLeft).duration(300).onEnd {
            endAction?.invoke()
            visibility = View.GONE
        }.playOn(this)
    }
}


fun View?.scaleUp(endAction: (() -> Unit)? = null) {
    this?.apply {
        animate().scaleX(1f).scaleY(1f).setDuration(250).withEndAction {
            endAction?.invoke()
        }.start()
    }
}

fun View?.scaleDown(endAction: (() -> Unit)? = null) {
    this?.apply {
        animate().scaleX(0.7f).scaleY(0.7f).setDuration(250).withEndAction {
            endAction?.invoke()
        }.start()
    }
}

fun View?.rotateRight(endAction: (() -> Unit)? = null) {
    this?.apply {
        animate().rotation(180f).setDuration(200).withEndAction {
            endAction?.invoke()
        }.start()
    }
}

fun View?.rotateLeft(endAction: (() -> Unit)? = null) {
    this?.apply {
        animate().rotation(0f).setDuration(200).withEndAction {
            endAction?.invoke()
        }.start()
    }
}


fun View?.isVisible(): Boolean {
    if (this == null) {
        return false
    }
    return visibility == View.VISIBLE
}


fun View?.fadeIn(duration: Long = 300, delay: Long = 0, endAction: (() -> Unit)? = null) {
    YoYo.with(Techniques.FadeIn).delay(delay).duration(duration).onEnd {
        endAction?.invoke()
    }.playOn(this)
}


fun View?.fadeout(duration: Long = 300, delay: Long = 0, endAction: (() -> Unit)? = null) {
    YoYo.with(Techniques.FadeOut).delay(delay).duration(duration).onEnd {
        endAction?.invoke()
    }.playOn(this)
}

fun valueAnimator(duration: Long, from: Int, to: Int, delay: Long = 0L, increaseAction: ((Int) -> Unit)? = null): ValueAnimator {
    val va = ValueAnimator.ofInt(from, to)
    va.duration = duration
    va.startDelay = delay
    va.addUpdateListener { animation ->
        increaseAction?.invoke(animation.animatedValue as Int)
    }
    return va
}

fun View.hideInvisible() {
    if (visibility != View.INVISIBLE) {
        visibility = View.INVISIBLE
    }
}

fun View.hideGone() {
    if (visibility != View.GONE) {
        visibility = View.GONE
    }
}

fun View.show() {
    if (visibility != View.VISIBLE) {
        visibility = View.VISIBLE
    }
}

internal inline fun <reified T : Any> T.log(text: String) {
    Log.d(T::class.java.simpleName, text)
}
