import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => <Object>[];
}

class NavigateToHome extends SplashEvent {
  const NavigateToHome();

  @override
  List<Object> get props => <Object>[];
}


