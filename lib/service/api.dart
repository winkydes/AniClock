import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future getCurrentSeasonalAnime(int pageNum) async {
    String season = "";
    switch (DateTime.now().month) {
      case 1:
      case 2:
      case 3:
        season = "winter";
        break;
      case 4:
      case 5:
      case 6:
        season = "spring";
        break;
      case 7:
      case 8:
      case 9:
        season = "summer";
        break;
      case 10:
      case 11:
      case 12:
        season = "fall";
        break;
      default:
        season = "";
        break;
    }
    String url =
        "https://api.jikan.moe/v4/seasons/${DateTime.now().year}/$season?page=$pageNum";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  Future getAnimeById(int id) async {
    String url = "https://api.jikan.moe/v4/anime/$id";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }
}
