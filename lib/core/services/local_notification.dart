import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';


class LocalNotification {
  final AwesomeNotifications _aNotifications = AwesomeNotifications();

  Future<void> initialize() async {
    await _aNotifications.initialize(
      'IconsRes.notifyLogo',
      <NotificationChannel>[
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            importance: NotificationImportance.Max,
            ledColor: ColorsRes.accent)
      ],
    );
    await _aNotifications.isNotificationAllowed().then((bool isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<bool> createNotification() async => _aNotifications.createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: StringsRes.cleanDevice,
          body: StringsRes.cleanDeviceBody,
          autoDismissible: true,
          wakeUpScreen: true,
          displayOnForeground: false,
          locked: true,
          largeIcon: 'IconsRes.notifyIcon',
        ),
        schedule: NotificationInterval(
          interval: 10800,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          repeats: false,
        ),
      );

  Future<void> disableNotification() => _aNotifications.cancelAll();
}
