import 'package:cleaner_code_review/core/enums/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => <Object>[];
}

class HomeInitial extends HomeState {}

class ConnectionChecked extends HomeState {
  const ConnectionChecked({required this.updateKey});

  final Key updateKey;

  @override
  List<Object> get props => <Object>[updateKey];
}

class PageChanged extends HomeState {
  const PageChanged({
    required this.pageNum,
    required this.pageType,
    required this.isRatted,
  });

  final int pageNum;
  final HomePageType pageType;
  final bool isRatted;

  @override
  List<Object> get props => <Object>[pageNum, pageType, isRatted];
}

class MemoryInfoGot extends HomeState {
  const MemoryInfoGot({
    required this.cacheValue,
    required this.trashValue,
  });

  final int cacheValue;
  final int trashValue;

  @override
  List<Object> get props => <Object>[cacheValue, trashValue];
}

class CleanCacheStarted extends HomeState {
  const CleanCacheStarted();

  @override
  List<Object> get props => <Object>[];
}

class CleanCacheFinished extends HomeState {
  const CleanCacheFinished();

  @override
  List<Object> get props => <Object>[];
}

class CacheCountCleaning extends HomeState {
  const CacheCountCleaning({required this.cache});

  final int cache;

  @override
  List<Object> get props => <Object>[cache];
}

class CleanTrashStarted extends HomeState {
  const CleanTrashStarted();

  @override
  List<Object> get props => <Object>[];
}

class CleanTrashFinished extends HomeState {
  const CleanTrashFinished();

  @override
  List<Object> get props => <Object>[];
}

class TrashCountCleaning extends HomeState {
  const TrashCountCleaning({required this.trash});

  final int trash;

  @override
  List<Object> get props => <Object>[trash];
}
