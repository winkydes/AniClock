import 'package:AniClock/pages/login.dart';
import 'package:AniClock/service/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../pages/calandar.dart';

class AddCalendarSheet extends StatefulWidget {
  final int animeId;
  final bool thisSeason;
  const AddCalendarSheet(
      {Key? key, required this.animeId, required this.thisSeason})
      : super(key: key);

  @override
  State<AddCalendarSheet> createState() => _AddCalendarSheetState();
}

class _AddCalendarSheetState extends State<AddCalendarSheet> {
  ApiService api = ApiService();
  bool logined = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<dynamic>(
        future: api.getAnimeById(widget.animeId),
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
            Map<String, dynamic> data = snapshot.data["data"];
            YoutubePlayerController _controller = YoutubePlayerController(
              initialVideoId: data["trailer"]["youtube_id"],
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: true,
              ),
            );
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.001),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.75,
                      minChildSize: 0.2,
                      maxChildSize: 0.75,
                      builder: (_, controller) {
                        return Stack(children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                  child: Divider(
                                    color: Theme.of(context).dividerColor,
                                    indent: width * 0.4,
                                    endIndent: width * 0.4,
                                    thickness: 8,
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Image.network(data["images"]
                                                ["jpg"]["image_url"])),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height * 0.02,
                                            left: width * 0.05,
                                            right: width * 0.05),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            data["title"],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: width * 0.05),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height * 0.02,
                                            left: width * 0.05,
                                            right: width * 0.05),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            data["title_japanese"],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: width * 0.05),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.05,
                                            0,
                                            width * 0.05,
                                            height * 0.05),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Airing from ${data["aired"]["from"].toString().substring(0, 10)}\n every ${data["broadcast"]["string"]}",
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.08, 0, width * 0.08, 20),
                                        child: YoutubePlayer(
                                          controller: _controller,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.08, 0, width * 0.08, 20),
                                        child: Text(
                                          data["synopsis"],
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height * 0.1),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: height,
                            width: width,
                            child: Container(
                              height: height * 0.1,
                              width: width,
                              color: Theme.of(context).backgroundColor,
                              padding: const EdgeInsets.all(10),
                              child: MaterialButton(
                                color: Theme.of(context).bottomAppBarColor,
                                child: logined? const Text("Add to Calendar!") : const Text("Login"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => logined? CalendarPage(
                                                fromDate: DateTime.parse(
                                                    data["aired"]["from"]),
                                                epNo: data["episodes"],
                                                title: data["title"],
                                                animeId: widget.animeId
                                              ): const LoginPage())));
                                },
                              ),
                            ),
                          )
                        ]);
                      }),
                ),
              ),
            );
          }
        });
  }
}
