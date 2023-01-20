import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final DateTime fromDate;
  final int? epNo;
  final String title;
  const CalendarPage(
      {Key? key,
      required this.fromDate,
      required this.epNo,
      required this.title})
      : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<DateTime> _selectedDayList = [];

  @override
  void initState() {
    setState(() {
      _selectedDay = widget.fromDate;
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
                onPressed: () {},
                child: const Text("Confirm!", style: TextStyle(color: Colors.white),),
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                _focusedDay = focusedDay;
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
