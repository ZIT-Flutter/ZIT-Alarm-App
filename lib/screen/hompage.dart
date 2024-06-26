import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      print('This is an android Device');
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text('ZIT Alarm App'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
                child: const Center(
                    child: Text(
                  'Ring Now',
                  textAlign: TextAlign.center,
                )),
                onPressed: () {}),
            FloatingActionButton(
              onPressed: () {
                AlarmSettings alarmSettings = AlarmSettings(
                    id: 1234,
                    dateTime: DateTime.now().add(const Duration(seconds: 20)),
                    assetAudioPath: 'assets/nokia.mp3',
                    notificationTitle: 'Alarm Ringing',
                    notificationBody: 'Your Alarm is Ringing');

                Alarm.set(alarmSettings: alarmSettings);

                print('Your alarm is set successfully');

                // showModalBottomSheet(
                //     isScrollControlled: true,
                //     context: context,
                //     builder: (context) => DraggableScrollableSheet(
                //           initialChildSize: 0.7,
                //           minChildSize: 0.3,
                //           builder: (context, controller) => Container(),
                //         ));
              },
              child: const Icon(Icons.alarm),
            )
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) => const ListTile(
                title: Text('9: 41 AM'),
                trailing: Icon(Icons.arrow_forward_ios),
              )),
    );
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }
}
