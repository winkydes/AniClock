import 'package:AniClock/pages/tempholder.dart';
import 'package:flutter/material.dart';

import 'ViewSeasonOption.dart';
import 'account.dart';

class BaseHomePage extends StatefulWidget {
  const BaseHomePage({Key? key}) : super(key: key);

  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  int selectedIndex = 0;

  var widgetOptions = [
    const HomePage(),
    const InfoPage(),
    const ResourcePage(),
    const AccountPage(),
  ];

  BottomAppBar botBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                icon: const Icon(Icons.home)),
          ),
          Expanded(
            child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                icon: const Icon(Icons.show_chart)),
          ),
          const Expanded(child: Text('')),
          Expanded(
            child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
                icon: const Icon(Icons.tab)),
          ),
          Expanded(
            child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                },
                icon: const Icon(Icons.person)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AniClock"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ViewSeasonOptionPage()));
        },
        child: const Icon(Icons.calendar_today_outlined),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center
      bottomNavigationBar: botBar(),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
    );
  }
}
