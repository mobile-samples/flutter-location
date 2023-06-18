import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../company_model.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({Key? key, required this.company}) : super(key: key);
  final Company company;

  @override
  Widget build(BuildContext context) {
    int catLength = company.categories == null ? 0 : company.categories!.length;
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company.name ?? ''),
              SizedBox(width: 0, height: 5),
              Text(company.description ?? ''),
              Text(company.size.toString()),
              SizedBox(width: 0, height: 5),
              Row(
                children: [
                  for (int i = 0; i < catLength; i++) ...[
                    DecoratedBox(
                      child: Padding(
                        padding: new EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                        child: Text(company.categories![i]),
                      ),
                      decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(10.0)),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 5, height: 0),
                  ]
                ],
              ),
              SizedBox(width: 0, height: 5),
            ],
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
