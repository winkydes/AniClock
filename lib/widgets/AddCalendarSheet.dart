import 'package:AniClock/service/api.dart';
import 'package:flutter/material.dart';

class AddCalendarSheet extends StatefulWidget {
  final int animeId;
  const AddCalendarSheet({Key? key, required this.animeId}) : super(key: key);

  @override
  State<AddCalendarSheet> createState() => _AddCalendarSheetState();
}

class _AddCalendarSheetState extends State<AddCalendarSheet> {
  ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<dynamic>(
        future: api.getAnimeById(widget.animeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Theme.of(context).backgroundColor,
              height: height * 0.75,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else {
            Map<String, dynamic> data = snapshot.data["data"];
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
                        return Container(
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
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
                                          width * 0.08, 0, width * 0.08, 20),
                                      child: Text(
                                        data["synopsis"],
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            );
          }
        });
  }
}
