import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'Monefy_channel',
          channelName: 'Pengingat Menabung',
          channelDescription: 'Notifikasi pengingat menabung Monefy',
          defaultColor: const Color(0xFF2EC4A0),
          ledColor: const Color(0xFF2EC4A0),
          importance: NotificationImportance.High,
        ),
      ],
      debug: false,
    );
  }

  static Future<bool> requestPermission() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<void> jadwalkanPengingat({
    required int id,
    required String namaCelengan,
    required int jam,
    required int menit,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'Monefy_channel',
        title: ' Waktunya Menabung!',
        body: 'Jangan lupa setor ke celengan "$namaCelengan" hari ini!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: jam,
        minute: menit,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> batalkanPengingat(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}