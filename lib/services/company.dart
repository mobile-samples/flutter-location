import 'dart:convert';
import 'package:flutter_user/common/HttpHelper.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';
import '../models/search.dart';

class CompanyService {
  CompanyService._instantiate();

  static final CompanyService instance = CompanyService._instantiate();
  static List<String> categories = [
    'Job Work/Life Balance',
    'Compensation/Benefits',
    'Job Security/Advancement',
    'Management',
    'Culture'
  ];

  Future<SearchResult<Company>> search(String input) async {
    String searchOption = '';
    if (input != '') {
      searchOption += 'name=$input';
    }
    searchOption += '&limit=20';
    late String baseUrl = HttpHelper.instance.getUrl();
    final response =
        await http.get(Uri.parse(baseUrl + '/companies/search?$searchOption'));

    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      SearchResult<Company> searchResult = SearchResult.fromJson(res);
      return searchResult;
    }

    throw json.decode(response.body)['error']['message'];
  }

  Future<Company> getByID(String id) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response = await http.get(Uri.parse(baseUrl + '/companies/$id'));

    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      Company company = Company.fromJson(res);
      return company;
    }

    throw json.decode(response.body)['error']['message'];
  }
}
