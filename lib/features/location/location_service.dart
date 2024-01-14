import 'dart:convert';
import 'package:flutter_user/features/location/location_model.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class LocationService {
  LocationService._instantiate();
  static final LocationService instance = LocationService._instantiate();

  Future<SearchResult<Location>> search() async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/locations/search?limit=24'));
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      SearchResult<Location> searchResult = SearchResult.fromJson(res);
      return searchResult;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<Location> getLocationDetail(String locationId) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/locations/$locationId'));
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      Location location = Location.fromJson(res);
      return location;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
