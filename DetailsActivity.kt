

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Intent
import android.support.v4.media.session.PlaybackStateCompat
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import androidx.activity.viewModels
import com.bitmovin.player.api.event.listener.OnTimeChangedListener
import com.bitmovin.player.config.PlayerConfiguration
import com.bitmovin.player.config.StyleConfiguration
import com.bitmovin.player.config.advertising.AdItem
import com.bitmovin.player.config.advertising.AdvertisingConfiguration
import com.bitmovin.player.config.media.SourceConfiguration
import io.reactivex.Observable
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposable
import kotlinx.android.synthetic.main.activity_details.*
import java.util.concurrent.TimeUnit

class DetailsActivity : MvpActivity<DetailsPresenter, DetailsView>(), DetailsView {
    internal lateinit var detailsViewModel: DetailsViewModel
    private val advertising = Advertising()
    private var amazonMediaVoiceControl: AmazonMediaVoiceControl = AmazonMediaVoiceControl()
    private lateinit var seekBarDetails: SeekBarDetails
    private lateinit var watchingAdditionalOptions: WatchingAdditionalOptions
    private var state: Int = STATE_DETAIL

    override fun initPresenter(): DetailsPresenter? {
        return DetailsPresenter(this)
    }

    override fun getLayoutResourceId(): Int {
        return R.layout.activity_details
    }

    override fun initData() {
        //NOTE: viewModel to to store and manage UI-related data in a lifecycle
        val viewModel: DetailsViewModel by viewModels()
        detailsViewModel = viewModel
        seekBarDetails = SeekBarDetails(this)
        detailsViewModel.detailsAnalytics = DetailsAnalytics(this)
        detailsViewModel.sharedPreference = PreferenceManager(this)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
        seekbar_.hideInvisible()
        btn_play_progress.visibility = View.VISIBLE
        btn_play.requestFocus()
        detailsViewModel.selectorStateAnimation.firstViewChangeStateAnimation(this, btn_play, wish_list_btn)

        val uri = intent.data
        if ((intent.action == Intent.ACTION_VIEW || intent.action == Intent.ACTION_SEARCH) && uri != null) {
            when (uri.pathSegments.firstOrNull()) {
                "video" -> uri.lastPathSegment?.let {
                    presenter?.getMovieByID(uri.lastPathSegment)
                }
            }
        } else {
            val m = intent?.getSerializableExtra(MOVIE)
            if (m is Movie) {
                detailsViewModel.movie = m
                updateBackground(detailsViewModel.movie)
            }
        }
        fetchIsAdsEnabled()
        watchingAdditionalOptions = WatchingAdditionalOptions(this, presenter)
        amazonMediaVoiceControl.initMedia(this, detailsViewModel.movie, watchingAdditionalOptions)

    }

    private fun fetchIsAdsEnabled() {
        val app: Application = application
        if (app is MainApplication) {
            //detailsViewModel.isAdsEnabled = app.remoteConfig.getBoolean("adsEnable")
            //advertising.isTestAdsEnable = app.remoteConfig.getBoolean("testAdsEnable")
            app.remoteConfig.fetchAndActivate()
                    .addOnCompleteListener(this) {
                        //detailsViewModel.isAdsEnabled = app.remoteConfig.getBoolean("adsEnable")
                        //advertising.isTestAdsEnable = app.remoteConfig.getBoolean("testAdsEnable")
                    }
        }
    }

    override fun setListeners() {
        btn_play?.run {
            setOnClickListener {
                detailsViewModel.showDetails = true
                stopAutoPlayMovie()
                startPlayerButton()
                detailsViewModel.detailsAnalytics.playTracker()
            }
        }
        wish_list_btn?.setOnClickListener {
            addToWatchList()
        }
        btn_wish_list_2?.setOnClickListener {
            hideDetailsMovie()
        }
        btn_resume?.setOnClickListener {
            resumePlayerButton()
        }
        btn_start_over?.setOnClickListener {
            startOverPlayerButton()
        }
        btn_play?.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) detailsViewModel.selectorStateAnimation.firstViewChangeStateAnimation(this, btn_play, wish_list_btn)
            else detailsViewModel.selectorStateAnimation.secondViewChangeStateAnimation(this, wish_list_btn, btn_play)
        }
        btn_resume?.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) detailsViewModel.selectorStateAnimation.secondViewChangeStateAnimation(this, btn_resume, btn_start_over)
            else detailsViewModel.selectorStateAnimation.secondViewChangeStateAnimation(this, btn_start_over, btn_resume)
        }
    }

    private fun setCustomAlertDialog() {
        val customAlertDialog = CustomAlertDialog(this, resources.getString(R.string.watchlist_sign_in_title),
                resources.getString(R.string.watchlist_sign_in_msg, detailsViewModel.movie?.title?.llTitle),
                resources.getString(R.string.sign_in), resources.getString(R.string.cancel))
        customAlertDialog.setOnDialogClickButtons(object : CustomAlertDialog.OnDialogClickButtons {
            override fun onDialogPositiveButton() {
                val intent = Intent(this@DetailsActivity, GenresActivity::class.java)
                intent.putExtra(Constants.FROM_DETAILS, true)
                startActivityForResult(intent, authResult)
                showProgressDialog()
            }

            override fun onDialogNegativeButton() = autoPlayMovie()
        })
    }

    @SuppressLint("CheckResult")
    private fun hideLogo() {
        detailsViewModel.autoHideLogo = Observable.timer(15000, TimeUnit.MILLISECONDS)
                .doOnSubscribe { this.addCompositeDisposable(it) }
                .lazySubscribe { img_logo.invisible() }
    }

    @SuppressLint("CheckResult")
    internal fun autoPlayMovie() {
        detailsViewModel.autoPlayMovie = Observable.timer(15000, TimeUnit.MILLISECONDS)
                .doOnSubscribe { this.addCompositeDisposable(it) }
                .lazySubscribe { startPlayerButton() }
    }

    private fun stopAutoPlayMovie() {
        val autoPlay: Disposable? = detailsViewModel.autoPlayMovie
        if (autoPlay != null) {
            getCompositeDisposable()?.remove(autoPlay)
            autoPlay.dispose()
        }
    }

    private fun addCompositeDisposable(disposable: Disposable) {
        getCompositeDisposable()?.add(disposable)
    }

    private fun getCompositeDisposable(): CompositeDisposable? {
        if (detailsViewModel.compositeDisposable == null || detailsViewModel.compositeDisposable?.isDisposed == true)
            detailsViewModel.compositeDisposable = CompositeDisposable()
        return detailsViewModel.compositeDisposable
    }

    override fun onSuccess(state: MvpViewState, response: Any?) {
        val titleId: String? = detailsViewModel.movie?.title?.id
        when (state) {
            DetailsView.DetailsStatesView.LOAD_WATCHLIST -> {
                if (response != null && response is List<*>) {
                    val titleResponse: List<TitleResponse> = response as List<TitleResponse>
                    for (item: TitleResponse in titleResponse) {
                        if (item.title?.id == titleId) {
                            watchListButtonRemove(true)
                            break
                        } else watchListButtonAdd(false)
                    }
                } else if (response != null && response is StatsResponse) {
                    val watchListState = response.stats?.watchlist
                    watchListState?.let {
                        if (it) watchListButtonRemove(it)
                        else watchListButtonAdd(it)
                    }
                }
            }

            DetailsView.DetailsStatesView.LOAD_NEXT -> {
                if (response != null && response is TitleResponse) {
                    val movieTitle: String? = response.title?.llTitle
                    val image: String? = response.title?.llHeroPosterURL
                    detailsViewModel.playerUI?.setWatchNextMovie(movieTitle, image)
                    detailsViewModel.title = response.title
                }
            }

            DetailsView.DetailsStatesView.LOAD_CONTINUE_WATCHING -> {
                if (response != null && response is List<*> && response.isNotEmpty()) {
                    val contWatchingResponse: List<ContinueWatchResponse> = response as List<ContinueWatchResponse>
                    for (item: ContinueWatchResponse in contWatchingResponse) {
                        if (item.title?.id == titleId) {
                            detailsViewModel.seekPosition = (item.durationMarker * 1000).toLong()
                            break
                        }
                    }
                }
                //seekTo(seekBarDetails.getContinueWatchingSeek())
                playButtonTextManager()
            }

            DetailsView.DetailsStatesView.LOAD_MOVIE_BY_ID -> {
                if (response != null && response is TitleResponse) {
                    detailsViewModel.movie = Movie()
                    detailsViewModel.movie?.title = response.title
                    if (detailsViewModel.isAuthorized) presenter?.getContinueWatchingResponse()
                    updateBackground(detailsViewModel.movie)
                    initializePlayer()
                    startPlayerButton()
                }
            }
        }
    }

    private fun seekTo(position: Long) {
        detailsViewModel.playerUI?.seekTo(position)
    }

    private fun initializePlayer() {
        val url: String? = detailsViewModel.movie?.title?.llVideoHLSURL
                ?: detailsViewModel.movie?.title?.llVideoMP4URL
        detailsViewModel.playerUI = createPlayerUI(url)
        detailsViewModel.playerUI?.addOnTimeChangeCallback(OnTimeChangedListener {
            val timeMs = Constants.convertSecondsToMillisecond(it.time.toLong()) // NOTE timeStampMs - millisecondSeconds
            detailsViewModel.seekPosition = timeMs
        })
        amazonMediaVoiceControl.setPlayerUi(detailsViewModel.playerUI)
        card_video_surface_container.addView(detailsViewModel.playerUI)
        detailsViewModel.playerUI?.onStart()
        amazonMediaVoiceControl.setMediaSessionState(PlaybackStateCompat.STATE_PLAYING)
    }

    private fun createPlayerUI(url: String?): PlayerUI {
        val styleConfiguration = StyleConfiguration()
        styleConfiguration.isUiEnabled = false
        val sourceConfiguration = SourceConfiguration()
        if (url != null) sourceConfiguration.addSourceItem(url)
        val playerConfiguration = PlayerConfiguration()
        playerConfiguration.styleConfiguration = styleConfiguration
        playerConfiguration.sourceConfiguration = sourceConfiguration
        return PlayerUI(this, playerConfiguration)
    }

    private fun prepareListeners() {
        amazonMediaVoiceControl.setMediaSessionState(PlaybackStateCompat.STATE_PLAYING)
        state = STATE_PLAYER
        seekBarDetails.playerSeekListener(detailsViewModel.playerUI, watchingAdditionalOptions)
        hideDetailsMovie()
        hideLogo()
    }

    internal fun startPlayerButton() {
        detailsViewModel.detailsAnalytics.fullScreenTracker()
        prepareListeners()
        playerConfig()

        if (isTrailer())
            seekTo(0L)
        else
            seekTo(seekBarDetails.getContinueWatchingSeek())


    }

    private fun isTrailer(): Boolean {
        return detailsViewModel.movie?.title?.llGenres?.contains("trailer") ?: false
    }


    private fun resumePlayerButton() {
        detailsViewModel.detailsAnalytics.resumeTracker()
        detailsViewModel.isResumeClicked = true
        detailsViewModel.autoPlayMovie?.dispose()
        detailsViewModel.detailsAnalytics.fullScreenTracker()
        prepareListeners()
        detailsViewModel.playerUI?.play()
//        playerPlay()
    }

    private fun startOverPlayerButton() {
        detailsViewModel.detailsAnalytics.startOverTracker()
        detailsViewModel.seekPosition = START_TIME
        detailsViewModel.isStartOverClicked = true
        playerConfig()
        prepareListeners()
        seekTo(START_TIME)
    }

    private fun addToWatchList() {
        if (detailsViewModel.isAuthorized) {
            watchingAdditionalOptions.addRemoveWatchListVideo(detailsViewModel.movie)
            val titleMovie: String? = detailsViewModel.movie?.title?.llTitle
                    ?: return
            detailsViewModel.detailsAnalytics.watchListTracker(titleMovie)
        } else {
            stopAutoPlayMovie()
            setCustomAlertDialog()
        }
    }

    fun updateAdsConfig(seekTime: Long) {
        playerConfig(true, seekTime)
    }

    private fun playerConfig(isAddPrevious: Boolean = false, seekTime: Long? = null) {
        val playerUI = detailsViewModel.playerUI ?: return
        val adBreaks = detailsViewModel.movie?.title?.llAdBreaks
        val playerConfig: PlayerConfiguration = playerUI.getPlayerConfig() ?: return
        val adBreakCountCurrent: Int = playerConfig.advertisingConfiguration?.schedule?.size
                ?: 0
        if (adBreaks != null && adBreaks.isNotEmpty() && detailsViewModel.isAdsEnabled) {
            val seekPos: Long = seekTime ?: if (detailsViewModel.isStartOverClicked) {
                detailsViewModel.isStartOverClicked = false
                START_TIME
            } else seekBarDetails.getContinueWatchingSeek()
            val adItems: List<AdItem> = advertising.configuration(adBreaks, playerUI, seekPos, isAddPrevious)
            if (adBreakCountCurrent != adItems.size) {
                playerConfig.advertisingConfiguration = AdvertisingConfiguration(*adItems.toTypedArray())
                playerUI.setPlayerConfig(playerConfig)
            }
        }
    }

    private fun watchListButtonRemove(addInWatchList: Boolean) {
        wish_list_btn.text = getString(R.string.bttn_remove)
        wish_list_btn.invalidate()
        detailsViewModel.isInWatchList = addInWatchList
    }

    private fun watchListButtonAdd(removeWatchList: Boolean) {
        wish_list_btn.text = getString(R.string.watch_list)
        wish_list_btn.invalidate()
        detailsViewModel.isInWatchList = removeWatchList
    }

    private fun playButtonTextManager() {
        btn_play_progress.visibility = View.GONE
        if (!isTrailer() && seekBarDetails.getContinueWatchingSeek() > 0L) btn_play_text.text = resources.getString(R.string.resume)
        else btn_play_text.text = resources.getString(R.string.play)
        btn_play_text.invalidate()
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        val player: PlayerUI? = detailsViewModel.playerUI
        return if (keyCode == KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE) {
            playerTogglePlayPause()
            true
        } else if (state == STATE_RESUME || state == STATE_START || player == null) {
            super.onKeyDown(keyCode, event)
        } else if (keyCode == KeyEvent.KEYCODE_DPAD_CENTER) {
            playerTogglePlayPause()
            true
        } else if (player.onKeyDownA(keyCode, event)) {
            true
        } else super.onKeyDown(keyCode, event)
    }

    private fun playerTogglePlayPause() {
        val isPlaying = detailsViewModel.playerUI?.isPlaying() ?: false
        if (isPlaying) {
            playerPause()
        } else {
            playerPlay()
        }
    }

    private fun playerPlay() {
        val player: PlayerUI = detailsViewModel.playerUI ?: return
        player.play()
        hideDetailsMovie()
    }

    internal fun playerPause() {
        val player: PlayerUI = detailsViewModel.playerUI ?: return
        player.pause()
        showDetailsMovie()
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        val player: PlayerUI? = detailsViewModel.playerUI
        return if (state == STATE_RESUME || state == STATE_START || player == null) super.onKeyUp(keyCode, event)
        else if (player.onKeyUpA(keyCode, event)) true
        else super.onKeyUp(keyCode, event)
    }

    internal fun setNextMovie() {
        detailsViewModel.playerUI?.stop()
        detailsViewModel.playerUI?.onDestroy()
        detailsViewModel.movie = Movie()
        detailsViewModel.movie?.title = detailsViewModel.title
        if (detailsViewModel.isAuthorized) presenter?.getContinueWatchingResponse()
        amazonMediaVoiceControl = AmazonMediaVoiceControl()
        amazonMediaVoiceControl.initMedia(this, detailsViewModel.movie, watchingAdditionalOptions)
        updateBackground(detailsViewModel.movie)
        initializePlayer()
        startPlayerButton()
    }

    private fun showDetailsMovie() {
        detailsViewModel.playerUI?.needStartPlayAfterPause = false
        //detailsViewModel.playerUI?.pause()
        saveContinueWatching()
        amazonMediaVoiceControl.setMediaSessionState(PlaybackStateCompat.STATE_PAUSED)
        detailsViewModel.playerUI?.hideProgressUi()
        detailsViewModel.playerUI?.run {
            seekBarDetails.updateDetailsSeekBar(seekbar_, getCurrentTime(), getDuration())
        }
        layout_play?.visibility = View.GONE
        layout_resume?.visibility = View.VISIBLE
        frame_mask?.visibility = View.VISIBLE
        btn_resume?.requestFocus()
        state = STATE_RESUME
        if (img_logo.visibility == View.INVISIBLE) img_logo.apply {
            this.alpha = 1f
            this.visibility = View.VISIBLE
        }
        layout_detail?.showInfo {}
    }

    private fun hideDetailsMovie() {
        state = STATE_PLAYER
        goneMask()
    }

    private fun updateBackground(movie: Movie?) {
        state = STATE_DETAIL
        movie_info?.setMovie(movie)
        img_movie_thumb?.loadImage(this, movie?.title?.llHeroPosterURL)
    }

    private fun goneMask() {
        frame_mask.visibility = View.GONE
        img_movie_thumb.visibility = View.INVISIBLE
        layout_detail.visibility = View.GONE
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (data == null) return
        if (requestCode == authResult) {
            hideProgressDialog()
            watchingAdditionalOptions.addRemoveWatchListVideo(detailsViewModel.movie)
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onBackPressed() {
        val isAdsPlaying = detailsViewModel.playerUI?.isAdsPlaying() ?: return
        if (!isAdsPlaying) {
            detailsViewModel.detailsAnalytics.backPressedTracker()
            stopAutoPlayMovie()
            try {
                if (state == STATE_RESUME || state == STATE_DETAIL || state == STATE_START && layout_detail.isVisible()) {
                    returnToMain()
                    super.onBackPressed()
                } else if (state == STATE_PLAYER) {
                    playerPause()
                }
            } catch (e: Exception) {
                Log.e("DetailsActivity", "Error back pressed $e")
                returnToMain()
            }
        }
    }

    private fun returnToMain() {
        val intent = Intent()
        intent.putExtra("needUpdateHomeList", detailsViewModel.isWatchListClicked || detailsViewModel.isAddedToContWatch)
        setResult(Activity.RESULT_OK, intent)
        detailsViewModel.showDetails = false
        detailsViewModel.playerUI?.onStop()
        detailsViewModel.playerUI?.onDestroy()
    }

    override fun onStart() {
        super.onStart()
        detailsViewModel.playerUI?.onStart()
    }

    override fun onResume() {
        super.onResume()
        detailsViewModel.isAuthorized = detailsViewModel.sharedPreference.getUserIsAuthorized()
        if (detailsViewModel.showDetails) {
            playerPause()
        }
        if (detailsViewModel.playerUI == null) initializePlayer()
        else detailsViewModel.playerUI?.onResume()
        playButtonTextManager()
        if (detailsViewModel.isMediaSessionCommand) {
            stopAutoPlayMovie()
            detailsViewModel.isMediaSessionCommand = false
            state = STATE_PLAYER
        } else {
            if (detailsViewModel.isAuthorized) {
                presenter?.getWatchListResponse()
                presenter?.getContinueWatchingResponse()
            } else {
                //seekTo(seekBarDetails.getContinueWatchingSeek())
            }
            state = STATE_START
            autoPlayMovie()
        }
        detailsViewModel.detailsAnalytics.detailsMovieTracker()
    }

    private fun saveContinueWatching() {
        watchingAdditionalOptions.saveContinueWatching(detailsViewModel.playerUI?.getCurrentTime()
                ?: 0L, detailsViewModel.movie)
    }

    override fun onPause() {
        detailsViewModel.showDetails = true
        saveContinueWatching()
        stopAutoPlayMovie()
        playerPause()
        super.onPause()
    }

    override fun onStop() {
        getCompositeDisposable()?.dispose()
        detailsViewModel.playerUI?.onStop()
        detailsViewModel.playerUI = null
        super.onStop()
    }

    override fun onDestroy() {
        getCompositeDisposable()?.dispose()
        amazonMediaVoiceControl.onDestroy()
        detailsViewModel.playerUI?.onDestroy()
        super.onDestroy()
    }

    companion object {
        const val MOVIE = "Movie"
        const val CONST_FF_FR_TIME = 300000L
        const val START_TIME = 0L
        // STATE SCREEN
        const val STATE_DETAIL = 1
        const val STATE_PLAYER = 2
        const val STATE_RESUME = 3
        const val STATE_START = 4
        const val authResult = 65
    }

}
