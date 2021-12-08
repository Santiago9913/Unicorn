import 'dart:io';

import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/event.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TextEditingController eventController = TextEditingController();

  List<Event> events = [];

  String dropdownValue = 'Colombia';

  Future<List<Event>> getEvents() async {
    return await FirebaseStorageController.getEvents();
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];

    events.forEach((Event event) {
      List<String> fecha = event.date.split("/");
      int year = int.parse(fecha[2]);
      int month = int.parse(fecha[0]);
      int day = int.parse(fecha[1]);

      List<String> horaInicio = event.timeStart.split(":");
      int hInicio = int.parse(horaInicio[0]);
      int mInicio = int.parse(horaInicio[1]);

      List<String> horaFinal = event.timeEnd.split(":");
      int hFinal = int.parse(horaFinal[0]);
      int mFinal = int.parse(horaFinal[1]);

      final DateTime startTime = DateTime(year, month, day, hInicio, mInicio);
      final DateTime endTime = DateTime(year, month, day, hFinal, mFinal);

      meetings.add(Meeting(
          event.getName +
              ": " +
              event.getDescription +
              '\n' +
              event.getTimeStart +
              ' - ' +
              event.getTimeEnd,
          startTime,
          endTime,
          const Color(0xFF3D5AF1),
          false));
    });

    return meetings;
  }

  @override
  void initState() {
    // TODO: implement initState
    getEvents().then((List<Event> value) {
      print(value);
      setState(() {
        events = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: //Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //children: [

            SfCalendar(
          view: CalendarView.month,
          showNavigationArrow: true,
          allowAppointmentResize: true,
          allowedViews: [
            CalendarView.month,
            CalendarView.week,
            CalendarView.day
          ],
          dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        )
        //]
        //)
        );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
