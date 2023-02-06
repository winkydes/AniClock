import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

class CalendarPage extends StatefulWidget {
  final DateTime fromDate;
  final int? epNo;
  final String title;
  final int animeId;
  const CalendarPage(
      {Key? key,
      required this.fromDate,
      required this.epNo,
      required this.title,
      required this.animeId})
      : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final List<DateTime> _selectedDayList = [];

  @override
  void initState() {
    setState(() {
      for (int i = 0; i < (widget.epNo ?? 12); i++) {
        _selectedDayList.add(widget.fromDate.add(Duration(days: i * 7)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Calendar'),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: TextButton(
            onPressed: () {
              final registration = <String, dynamic>{
                "uid": FirebaseAuth.instance.currentUser!.uid,
                "animeId": widget.animeId
              };
              db
                  .collection("registration")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "animeId": FieldValue.arrayUnion([widget.animeId])
              });
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Confirm!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCalendar(
              focusedDay: widget.fromDate,
              firstDay: widget.fromDate,
              lastDay:
                  widget.fromDate.add(Duration(days: (widget.epNo ?? 12) * 7)),
              onPageChanged: (focusedDay) {
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarBuilders: CalendarBuilders(
                prioritizedBuilder: (context, day, focusedDay) {
                  if (_selectedDayList.contains(day)) {
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
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                },
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Text(" = New Episodes Airing  "),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Text(" = Today's Date"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
