import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/presentation/resources/routes/route_name.dart';

class Navigation {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? to(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic>? toReplacement(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic>? toPageRoute<T>({required Widget page}) {
    return navigatorKey.currentState?.push(
      MaterialPageRoute<T>(builder: (BuildContext context) => page),
    );
  }

  Future<dynamic>?
      toPageRouteProvider<T, P extends StateStreamableSource<Object?>>({
    required Widget page,
    required P bloc,
  }) {
    return navigatorKey.currentState?.push(
      MaterialPageRoute<T>(builder: (BuildContext context) {
        return BlocProvider<P>.value(
          value: bloc,
          child: page,
        );
      }),
    );
  }

  Future<dynamic>? toRemoveUntil(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  void toPopUntil(String routeName) =>
      navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));

  void pop({dynamic arguments}) => navigatorKey.currentState?.pop(arguments);
}
