import 'dart:convert';

import 'package:flutter_de_android/station.dart';
import 'package:http/http.dart';

class StationRepository {
  Future<List<Station>> getStations() async {
    final url = "https://buchy.github.io/techbookfest6/stations.json";
    final Response response = await get(url).timeout(Duration(seconds: 3));
    final Iterable stationsJson = json.decode(response.body)['stations'];
    final List<Station> stations =
        stationsJson.map((station) => Station.fromJson(station)).toList();
    return stations;
  }
}
