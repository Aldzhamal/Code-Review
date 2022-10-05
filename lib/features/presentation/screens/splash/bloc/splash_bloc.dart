import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/routes/route_name.dart';
import 'package:cleaner_code_review/features/presentation/screens/splash/bloc/splash_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/splash/bloc/splash_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<NavigateToHome>(
      (NavigateToHome event, Emitter<SplashState> emit) async {
        Future<dynamic>.delayed(const Duration(seconds: 3), (){
          getIt<Navigation>().toReplacement(RouteName.home);
        });
      },
    );
  }
}
