// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:AniClock/service/api.dart';
import 'package:table_calendar/table_calendar.dart';

ApiService api = ApiService();

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

Future<Map<DateTime, List<Event>>> getEventSource(List<int> animeIdList) async {
  Map<DateTime, List<Event>> source = {};
  for (var element in animeIdList) {
    var anime = await api.getAnimeById(element);
    for (int i = 0; i < (anime["data"]["episodes"] ?? 12); i++) {
      source.addAll({
        DateTime.parse(anime["data"]["aired"]["from"]).add(Duration(days: i * 7)) : [Event(anime["data"]["title"])]
      });
    }
  }
  return source;
}
