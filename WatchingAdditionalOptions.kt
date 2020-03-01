
import java.util.*

class WatchingAdditionalOptions(detailsActivity: DetailsActivity, val presenter: DetailsPresenter?) {

    private var detailsViewModel: DetailsViewModel? = detailsActivity.detailsViewModel

    internal fun addRemoveWatchListVideo(movie: Movie?) {
        detailsViewModel?.isWatchListClicked = true
        val watchListRequest = WatchListRequest()
        watchListRequest.titleID = movie?.title?.id
        watchListRequest.watchlist = !(detailsViewModel?.isInWatchList ?: return)
        watchListRequest.setWatchlist = true

        presenter?.addRemoveWatchList(watchListRequest)
    }

    internal fun saveContinueWatching(positionSeek: Long, movie: Movie?) {
        if (movie == null) return
        if (movie.title?.llGenres?.contains("trailer") == true) return
        if (detailsViewModel?.isAuthorized == true) saveContinueWatchingServer(positionSeek / 1000, movie)
        saveContinueWatchingLocally(positionSeek, movie)
    }

    private fun saveContinueWatchingServer(positionSeek: Long, movie: Movie) {
        detailsViewModel?.isAddedToContWatch = true
        val continueWatchingRequest = ContinueWatchingRequest()
        continueWatchingRequest.titleID = movie.title?.id
        continueWatchingRequest.durationMarker = positionSeek
        continueWatchingRequest.setDurationMarker = true
        presenter?.setContinueWatchingMoviesByUser(continueWatchingRequest)
    }

    private fun saveContinueWatchingLocally(positionSeek: Long, movie: Movie) {
        detailsViewModel?.let {
            if (!it.isAuthorized) it.isAddedToContWatch = !it.isAlreadyInContinueWatch
            val title: Title = movie.title ?: return

            if (positionSeek > 0) {
                when {
                    //NOTE:AddContWatchProgress
                    it.isLocalAddToContWatching -> {
                        title.positionSeek = positionSeek
                        it.sharedPreference.addContinueWatch(title)
                    }
                    //NOTE:removeContWatchProgress
                    !it.isLocalAddToContWatching -> {
                        it.sharedPreference.removeContinueWatch(title)
                    }
                }
            }
        }
    }

    internal fun getWatchNext(titleId: String) = presenter?.getWatchNext(titleId)

    internal fun setWatchAgain(title: String?) {
        val list: HashSet<String> = hashSetOf()
        val id = title ?: return
        list.add(id)
        detailsViewModel?.sharedPreference?.setWatchAgainList(list)
    }

}