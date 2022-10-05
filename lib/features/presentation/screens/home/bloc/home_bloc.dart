import 'package:bloc/bloc.dart';
import 'package:cleaner_code_review/core/network/network_info.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/routes/route_name.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_state.dart';
import 'package:cleaner_code_review/features/utils/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:storage_space/storage_space.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<ChangePage>(
      (ChangePage event, Emitter<HomeState> emit) async {
        final bool _isRatted = await getIt<Storage>().getIsUserRatted();
        final bool _isShared = await getIt<Storage>().getIsUserShared();

        emit(PageChanged(
          pageType: event.pageType,
          pageNum: event.pageNum,
          isRatted: _isRatted,
        ));
         await getIt<InterstitialAds>().loadInterstitialAd();
      },
    );
    on<NavigateToSettings>(
      (NavigateToSettings event, Emitter<HomeState> emit) {
        getIt<Navigation>().to(RouteName.settings);
      },
    );
    on<CheckInternetConnection>(
        (CheckInternetConnection event, Emitter<HomeState> emit) async {
      await NetworkInfoData().isConnected.then((bool isConnected) {
        if (!isConnected) {
          emit(ConnectionChecked(updateKey: UniqueKey()));
        }
      });
    });

    on<GetMemoryInfo>(
      (GetMemoryInfo event, Emitter<HomeState> emit) async {
        await _getMemoryInfo(emit: emit);
      },
    );

    on<StartCleanCache>(
      (StartCleanCache event, Emitter<HomeState> emit) {
        emit(const CleanCacheStarted());
      },
    );

    on<FinishCleanCache>(
      (FinishCleanCache event, Emitter<HomeState> emit) {
        emit(const CleanCacheFinished());
      },
    );

    on<CleaningCacheCount>(
      (CleaningCacheCount event, Emitter<HomeState> emit) {
        int _value = event.cache;
        emit(CacheCountCleaning(cache: _value -= 10));
      },
    );

    on<StartCleanTrash>(
      (StartCleanTrash event, Emitter<HomeState> emit) {
        emit(const CleanTrashStarted());
      },
    );

    on<FinishCleanTrash>(
      (FinishCleanTrash event, Emitter<HomeState> emit) {
        emit(const CleanTrashFinished());
      },
    );

    on<CleaningTrashCount>(
      (CleaningTrashCount event, Emitter<HomeState> emit) {
        int _value = event.trash;
        emit(TrashCountCleaning(trash: _value -= 10));
      },
    );
  }

  Future<StorageSpace> get _memoryInfo =>
      getStorageSpace(lowOnSpaceThreshold: 2147483648, fractionDigits: 1);

  Future<void> _getMemoryInfo({required Emitter<HomeState> emit}) async {
    await _memoryInfo.then((StorageSpace space) async {
      await getIt<Storage>().getIsEnabledNotify().then((bool enabled) async {
        if (enabled) {
            await getIt<LocalNotification>().createNotification();
        }
      });
      emit(MemoryInfoGot(
        cacheValue: space.free,
        trashValue: space.free,
      ));
    });
  }
}
