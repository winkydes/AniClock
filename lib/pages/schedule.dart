import 'dart:collection';

import 'package:AniClock/eventUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:AniClock/eventUtils.dart' as eventUtils;

var db = FirebaseFirestore.instance;

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<SchedulePage> {
  bool loading = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final _events = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  DateTime getSeasonFirstDate() {
    DateTime initDate = DateTime.now();
    switch (DateTime.now().month) {
      case 1:
      case 2:
      case 3:
        initDate = DateTime.parse("${DateTime.now().year}-01-01");
        break;
      case 4:
      case 5:
      case 6:
        initDate = DateTime.parse("${DateTime.now().year}-04-01");
        break;
      case 7:
      case 8:
      case 9:
        initDate = DateTime.parse("${DateTime.now().year}-07-01");
        break;
      case 10:
      case 11:
      case 12:
        initDate = DateTime.parse("${DateTime.now().year}-10-01");
        break;
      default:
        initDate = DateTime.now();
        break;
    }
    return initDate;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final docRef = db.collection("registration").doc(user?.uid);
    docRef.get().then((DocumentSnapshot doc) async {
      final idList = doc.data() as Map<String, dynamic>;
      List<int> idIntList = [];
      idList["animeId"].forEach((item) => idIntList.add(item));
      Map<DateTime, List<Event>> _eventList =
          await eventUtils.getEventSource(idIntList);
      setState(() {
        _events.addAll(_eventList);
      });
      setState(() {
        loading = false;
      });
    }, onError: (e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "My Schedule",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCalendar(
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    eventLoader: (day) {
                      return _getEventsForDay(day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    focusedDay: _focusedDay,
                    firstDay: getSeasonFirstDate(),
                    lastDay:
                        getSeasonFirstDate().add(const Duration(days: 365)),
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
