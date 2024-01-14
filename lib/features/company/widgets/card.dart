import 'package:flutter/material.dart';
import '../company_model.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({super.key, required this.company});
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
              const SizedBox(width: 0, height: 5),
              Text(company.description ?? ''),
              Text(company.size.toString()),
              const SizedBox(width: 0, height: 5),
              Row(
                children: [
                  for (int i = 0; i < catLength; i++) ...[
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                        child: Text(company.categories![i]),
                      ),
                    ),
                    const SizedBox(width: 5, height: 0),
                  ]
                ],
              ),
              const SizedBox(width: 0, height: 5),
            ],
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
