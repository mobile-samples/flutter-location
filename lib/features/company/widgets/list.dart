import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/features/company/company_model.dart';
import 'package:flutter_user/features/company/company_service.dart';

import 'card.dart';
import 'detail.dart';

class CompanyListWidget extends StatefulWidget {
  const CompanyListWidget({Key? key}) : super(key: key);

  @override
  State<CompanyListWidget> createState() => _CompanyListWidgetState();
}

class _CompanyListWidgetState extends State<CompanyListWidget> {
  late List<Company> companies;

  // late List<MapEntry<String, List<Location>>> list;
  late int total;
  bool _loading = true;
  late TextEditingController _searchCompaniesController;

  @override
  void initState() {
    super.initState();
    getCompanies();
    _searchCompaniesController = TextEditingController(text: '');
  }

  getCompanies() async {
    final res = await CompanyService.instance.search('');
    setState(() {
      companies = res.list;
      total = res.total;
      _loading = false;
    });
  }

  searchCompanies(String textInput) async {
    setState(() {
      _loading = true;
    });
    final res = await CompanyService.instance.search(textInput);
    setState(() {
      companies = res.list;
      total = res.total;
      _loading = false;
    });
  }

  gotoCompanyDetail(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyDetail(companyID: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        valueColor: new AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      ));
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 0, height: 20),
            Text(
              "Search companies",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CupertinoSearchTextField(
              controller: _searchCompaniesController,
              onSubmitted: (textInput) {
                searchCompanies(textInput);
              },
              onSuffixTap: () {
                _searchCompaniesController.clear();
                searchCompanies('');
              },
            ),
            SizedBox(width: 0, height: 20),
            Text("Company list",
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(width: 0, height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: companies.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    gotoCompanyDetail(companies[index].id.toString());
                  },
                  child: CompanyCard(
                    company: companies[index],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
