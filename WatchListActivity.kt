

import android.app.Activity
import android.content.Intent
import android.view.View
import kotlinx.android.synthetic.main.activity_watchlist.*

class WatchListActivity : MvpActivity<WatchListPresenter, WatchListView>(), WatchListView {

    private lateinit var watchListVideoFragment: WatchListVideoFragment
    var needUpdateHomeList = true

    override fun initPresenter(): WatchListPresenter? {
        return WatchListPresenter(this)
    }

    override fun getLayoutResourceId(): Int {
        return R.layout.activity_watchlist
    }

    override fun initData() {
        watchListVideoFragment = WatchListVideoFragment()
        watchListVideoFragment.setOnPreviewRowSelectedListener(object : WatchListVideoFragment.OnPreviewRowSelectedListener {
            override fun onSetMovieInfo(movie: Movie) {}
            override fun onFirstItem(isFirst: Boolean) {}
            override fun onMoreItem(movie: Movie) {}
            override fun onChangeBackground(isChanged: Boolean) {}
        })
        addFragment(watchListVideoFragment, layoutId = R.id.video_watch_list)
        presenter?.getWatchListResponse()
    }

    override fun setListeners() {}

    override fun onSuccess(state: MvpViewState, response: Any?) {
        when (state) {
            WatchListView.WatchListViewState.LOAD_CONTENT -> {
                val category = Category()
                category.label = ""
                val newMovieList: MutableList<Movie> = arrayListOf()
                if (response != null && response is List<*>) {
                    val titleResponse: List<TitleResponse> = response as List<TitleResponse>
                    if (titleResponse.isNotEmpty()) {
                        video_watch_list.visibility = View.VISIBLE
                        text_watch_list.visibility = View.GONE
                        for (item: TitleResponse in titleResponse) {
                            val movie = Movie()
                            movie.title = item.title
                            if (!newMovieList.contains(movie)) {
                                newMovieList.add(movie)
                                category.results = newMovieList
                                category.total = newMovieList.size
                                category.loopMode = false
                                category.moreResults = false
                                category.paginate = true
                            }
                        }
                        watchListVideoFragment.updateData(category, "")
                    } else{
                        video_watch_list.visibility = View.GONE
                        text_watch_list.visibility = View.VISIBLE
                    }
                }
            }
            WatchListView.WatchListViewState.ERROR -> {
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (data == null) return
        when (requestCode) {
            mainResult -> {
                this.needUpdateHomeList = data.getBooleanExtra("needUpdateHomeList", false)
                if (this.needUpdateHomeList) presenter?.getWatchListResponse()
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onResume() {
        super.onResume()
        setAnalyticsTracker(this@WatchListActivity, "WatchList screen", "Events", "Launched", "")
    }

    override fun onBackPressed() {
        val intent = Intent()
        intent.putExtra("needUpdateHomeList", true)
        setResult(Activity.RESULT_OK, intent)
        super.onBackPressed()
    }

}