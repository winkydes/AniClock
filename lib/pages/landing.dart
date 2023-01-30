import 'package:AniClock/service/api.dart';
import 'package:flutter/material.dart';

import '../widgets/AddCalendarSheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService api = ApiService();
  List<dynamic> currentSeasonAnimeList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.01),
          child: const Text(
            "Trending Animes This Season",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
            height: height * 0.3,
            child: FutureBuilder<dynamic>(
                future: api.getCurrentSeasonalAnime(0),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      height: height * 0.75,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data["data"].length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.03, 0, width * 0.03, height * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return AddCalendarSheet(
                                        animeId: snapshot.data["data"]
                                            .elementAt(index)["mal_id"],
                                        thisSeason: true,
                                      );
                                    });
                              },
                              child: Image.network(snapshot.data["data"]
                                      .elementAt(index)["images"]["jpg"]
                                  ["image_url"]),
                            ),
                          );
                        }));
                  }
                })),
      ],
    ));
  }
}
