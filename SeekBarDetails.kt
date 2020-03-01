

import android.widget.SeekBar


internal class SeekBarDetails(private val detailsActivity: DetailsActivity) {

    private var detailsViewModel: DetailsViewModel? = detailsActivity.detailsViewModel

    internal fun updateDetailsSeekBar(seekBar: SeekBar, current: Long, duration: Long) {
        seekBar.show()
        seekBar.run {
            max = (duration / 1000).toInt()
            progress = (current / 1000).toInt()
        }
    }

    internal fun getContinueWatchingSeek(): Long {
        val local = getContinueWatchingSeekLocally()
        val server = detailsViewModel?.seekPosition
        return if (detailsViewModel?.isAuthorized == true && detailsViewModel?.isResumeClicked == false && detailsViewModel?.isMediaSessionCommand == false) {
            if (server != null && local < server) {
                server
            } else
                local
        } else local
    }

    internal fun playerSeekListener(playerUI: PlayerUI?, watchingAdditionalOptions: WatchingAdditionalOptions) {
        playerUI?.setOnSeekBarListener(object : PlayerUI.OnSeekBarListener {
            override fun startNextMovie() {
                detailsActivity.setAnalyticsTracker(detailsActivity, "Details Movie screen", "Start Next Movie", "Launched", "")
                detailsActivity.setNextMovie()
            }

            override fun getWatchNextOption() {
                val titleId: String = detailsViewModel?.movie?.title?.id ?: return
                watchingAdditionalOptions.getWatchNext(titleId)
            }

            override fun saveSeekTimeToContinueWatching() {
                detailsViewModel?.let {
                    watchingAdditionalOptions.saveContinueWatching(playerUI.getCurrentTime(), it.movie)
                    seekProgressTracker(playerUI)
                }
            }

            override fun removeFromContinueWatching() {
                detailsViewModel?.isLocalAddToContWatching = false
                watchingAdditionalOptions.setWatchAgain(detailsViewModel?.movie?.title?.id)
            }

            override fun addAdsConfig(seekTime: Long) {
                detailsActivity.updateAdsConfig(seekTime)
            }
        })
    }

    private fun seekProgressTracker(playerUI: PlayerUI?) {
        val positionSecond: Long = playerUI?.getCurrentTimeInSeconds() ?: return
        val positionSeek: Int = playerUI.getCurrentTime().toInt().div(100)
        val progress = "Second: $positionSecond percentage: $positionSeek % "
        detailsActivity.setAnalyticsTracker(detailsActivity, "Details Movie screen", progress, "Launched", "")
    }

    private fun getContinueWatchingSeekLocally(): Long {
        detailsViewModel?.let {
            it.isResumeClicked = false
            val movieSeekList: List<Title> = it.sharedPreference.getContinueWatch()
            val titleId: String? = it.movie?.title?.id
            for (title: Title in movieSeekList) {
                if (title.id == titleId) {
                    it.seekPosition = title.positionSeek
                    if (title.positionSeek > 0) {
                        it.isAlreadyInContinueWatch = true
                        return title.positionSeek
                    }
                }
            }
        }
        return START_TIME
    }
}