


import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.view.inputmethod.InputMethodManager
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import kotlinx.android.synthetic.main.activity_ratings.*
import java.util.*
import javax.inject.Inject


class RatingsActivity : BaseActivity(), View.OnClickListener {

    @Inject
    lateinit var preference: IPreferenceManager
    @Inject
    lateinit var ratingsManager: IRatingsManager

    private lateinit var toUserId: String
    private lateinit var userPic: String
    private lateinit var userName: String
    private lateinit var ratingsAdapter: RatingsAdapter
    lateinit var refreshLayout: SwipeRefreshLayout
    private var profile: UserModel? = null
    private lateinit var ratingsList: RecyclerView
    private lateinit var titleShop: TextView
    private lateinit var userIcon: ImageView
    private var usersRatedIds = ArrayList<String>()
    private var animUp: Animation? = null
    private var animDown: Animation? = null
    private var animFabUp: Animation? = null
    private var animFabDown: Animation? = null
    private val reviews: ArrayList<RespondRatingsModel> = ArrayList()
    private var alreadyRatedList: Boolean = false
    private lateinit var imm: InputMethodManager

    override fun onCreate(savedInstanceState: Bundle?) {
        BaseComponent.create(this).inject(this)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ratings)

        profile = preference.getProfile()
        toUserId = intent.getStringExtra("user_id_to")
        userPic = intent.getStringExtra("user_pic_icon")
        userName = intent.getStringExtra("user_name_first")

        ratingsList = findViewById<View>(R.id.ratings_list) as RecyclerView
        val layoutManager = LinearLayoutManager(this, RecyclerView.VERTICAL,
                false)
        ratingsList.layoutManager = layoutManager
        ratingsList.setHasFixedSize(true)
        ratingsAdapter = RatingsAdapter(this@RatingsActivity)
        ratingsList.adapter = ratingsAdapter

        refreshLayout = findViewById<View>(R.id.swiperefresh_rate) as SwipeRefreshLayout
        refreshLayout.setColorSchemeColors(ContextCompat.getColor(this, R.color.primary))
        refreshLayout.setOnRefreshListener { refreshRatings() }
        imm = this.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        toolbar = findViewById(R.id.toolbar)
        initToolbar(true)

        add_rate_fab.setOnClickListener(this)
        add_rate_fab.setColorFilter(Color.WHITE)
        add_rate_fab.rippleColor = Color.LTGRAY
        rate_close.setOnClickListener(this)
        rating_bar.setOnClickListener(this)
        rate_send_button.setOnClickListener(this)

        animUp = AnimationUtils.loadAnimation(this, R.anim.enter_f_down)
        animDown = AnimationUtils.loadAnimation(this, R.anim.leave_to_down)
        animFabDown = AnimationUtils.loadAnimation(this, R.anim.leave_to_down_fab)
        animFabUp = AnimationUtils.loadAnimation(this, R.anim.enter_f_down_fab)

        titleShop = findViewById(R.id.name_shop)
        userIcon = findViewById(R.id.icon_shop)

        if (userPic.isNotEmpty()) {
            Glide.with(this).load(userPic)
                    .apply(RequestOptions.circleCropTransform())
                    .into(userIcon)
        }
        titleShop.text = userName

        getRateReview(toUserId)

        refreshLayout.isEnabled = !reviews.isNullOrEmpty()

    }

    override fun onClick(v: View?) {
        when (v) {
            add_rate_fab -> {
                if (addrate_layout.visibility == View.GONE) {
                    hideFabAnimation()
                    addrate_layout.startAnimation(animUp)
                    addrate_layout.visibility = View.VISIBLE
                }
            }
            rate_close -> {
                if (addrate_layout.visibility == View.VISIBLE) {
                    if (imm.isAcceptingText) dismissKeyboard()
                    addrate_layout.startAnimation(animDown)
                    addrate_layout.visibility = View.GONE
                    add_rate_fab.show()
                    add_rate_fab.animate().scaleX(1.0f).scaleY(1.0f)
                            .setDuration(350).start()
                    add_rate_fab.startAnimation(animFabUp)
                }
            }
            rate_send_button -> {
                sendReviewAction()
            }
        }
    }

    private fun sendReviewAction() {
        if (rate_edit_text.text.toString() != "" && rating_bar.rating.toInt() != 0) {
            val id = toUserId
            val ratings = RequestRatingsModel(
                    id,
                    rate_edit_text.text.toString(),
                    rating_bar.rating.toInt()
            )
            ratingsList.smoothScrollToPosition(reviews.size)
            sendReview(ratings)
            if (imm.isAcceptingText) dismissKeyboard()
            addrate_layout.startAnimation(animDown)
            addrate_layout.visibility = View.GONE
        } else {
            val message = getString(R.string.no_rate_stars)
            Toast.makeText(this@RatingsActivity, message, Toast.LENGTH_SHORT).show()
        }
    }

    @SuppressLint("CheckResult")
    fun sendReview(review: RequestRatingsModel) {
        ratingsManager.sendReview(review)
                .subscribe({
                    getRateReview(toUserId)
                }, { e ->
                    println("Error" + e.localizedMessage)
                })
    }

    @SuppressLint("CheckResult")
    fun getRateReview(toUserId: String?) {
        if (toUserId == null) return
        ratingsManager.getReviews(toUserId)
                .doOnSubscribe { refreshLayout.isRefreshing = true }
                .doOnSuccess { refreshLayout.isRefreshing = false }
                .doOnError { refreshLayout.isRefreshing = false }
                .subscribe({ ratingsModel ->
                    if (ratingsModel.isNullOrEmpty()) {
                        nothing_to_show_rate.visibility = View.VISIBLE
                    } else {
                        nothing_to_show_rate.visibility = View.GONE

                        if (ratingsModel.size > reviews.size) {
                            reviews.clear()
                            reviews.addAll(ratingsModel)
                            reviews.reverse()
                            ratingsAdapter.setListItems(reviews)
                            ratingsList.scrollToPosition(reviews.size - 1)
                        }
                        for (item in ratingsModel) {
                            val userId = item.user.id ?: return@subscribe
                            usersRatedIds.add(userId)
                            setFabVisibility()
                        }

                    }

                }, { e ->
                    println("Error" + e.localizedMessage)
                })
    }

    private fun setFabVisibility() {
        if (!usersRatedIds.isNullOrEmpty()) alreadyRatedList = usersRatedIds.contains(profile?.id)
        val showHideFab = profile?.id == toUserId || alreadyRatedList
        if (showHideFab) hideFabAnimation()
        else add_rate_fab.show()
    }

    private fun hideFabAnimation() {
        add_rate_fab.animate().scaleX(0.0f).scaleY(0.0f)
                .setDuration(400).start()
        add_rate_fab.startAnimation(animFabDown)
        if (animFabDown!!.hasEnded()) add_rate_fab.hide()
    }

    private fun dismissKeyboard() {
        imm.hideSoftInputFromWindow(this.currentFocus?.windowToken, 0)
    }

    private fun refreshRatings() {
        usersRatedIds.clear()
        getRateReview(toUserId)
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressed()
        return true
    }

}
