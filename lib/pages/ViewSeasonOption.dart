import 'dart:convert';

import 'package:AniClock/service/api.dart';
import 'package:AniClock/widgets/AddCalendarSheet.dart';
import 'package:flutter/material.dart';

class ViewSeasonOptionPage extends StatefulWidget {
  const ViewSeasonOptionPage({Key? key}) : super(key: key);

  @override
  State<ViewSeasonOptionPage> createState() => _ViewSeasonOptionPageState();
}

class _ViewSeasonOptionPageState extends State<ViewSeasonOptionPage> {
  ApiService api = ApiService();
  List<Map<String, dynamic>> animeList = [];
  int currentPage = 1;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // Setup the listener.
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          currentPage++;
          fetchCurrentSeasonAnimeList(currentPage);
        }
      }
    });

    fetchCurrentSeasonAnimeList(currentPage);
  }

  void fetchCurrentSeasonAnimeList(int pageNum) async {
    await api.getCurrentSeasonalAnime(pageNum).then((value) {
      if (value["data"] is List && value != null) {
        List resList = value["data"];
        for (var element in resList) {
          Map<String, dynamic> anime = {
            "id": element["mal_id"],
            "title": element["title"],
            "imageUrl": element["images"]["jpg"]["image_url"],
            "jpTitle": element["title_japanese"]
          };
          setState(() {
            animeList.add(anime);
          });
        }
        setState(() {
          currentPage = pageNum;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animes available now"),
      ),
      body: animeList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _controller,
              itemCount: animeList.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> displayAnime = animeList.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 15),
                        ]),
                    child: ListTile(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (builder) {
                                return AddCalendarSheet(animeId: displayAnime["id"], thisSeason: true,);
                              });
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor: Theme.of(context).hintColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        // trailing: const Text(
                        //   "GFG",
                        //   style: TextStyle(color: Colors.green, fontSize: 15),
                        // ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.network(
                              displayAnime["imageUrl"],
                              height: height * 0.15,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${displayAnime["title"]}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Text(
                                      "${displayAnime["jpTitle"]}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              }),
    );
  }
}
