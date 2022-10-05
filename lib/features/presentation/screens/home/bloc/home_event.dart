import 'package:cleaner_code_review/core/enums/enums.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => <Object>[];
}

class NavigateToSettings extends HomeEvent {
  const NavigateToSettings();

  @override
  List<Object> get props => <Object>[];
}

class CheckInternetConnection extends HomeEvent {
  const CheckInternetConnection();

  @override
  List<Object> get props => <Object>[];
}

class ChangePage extends HomeEvent {
  const ChangePage({required this.pageNum, required this.pageType});

  final int pageNum;
  final HomePageType pageType;

  @override
  List<Object> get props => <Object>[pageNum, pageType];
}

class GetMemoryInfo extends HomeEvent {
  const GetMemoryInfo();

  @override
  List<Object> get props => <Object>[];
}

class StartCleanCache extends HomeEvent {
  const StartCleanCache();

  @override
  List<Object> get props => <Object>[];
}

class FinishCleanCache extends HomeEvent {
  const FinishCleanCache();

  @override
  List<Object> get props => <Object>[];
}

class CleaningCacheCount extends HomeEvent {
  const CleaningCacheCount({required this.cache});

  final int cache;

  @override
  List<Object> get props => <Object>[cache];
}

class StartCleanTrash extends HomeEvent {
  const StartCleanTrash();

  @override
  List<Object> get props => <Object>[];
}

class FinishCleanTrash extends HomeEvent {
  const FinishCleanTrash();

  @override
  List<Object> get props => <Object>[];
}

class CleaningTrashCount extends HomeEvent {
  const CleaningTrashCount({required this.trash});

  final int trash;

  @override
  List<Object> get props => <Object>[trash];
}
