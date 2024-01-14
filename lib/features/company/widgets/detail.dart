import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/custom_appbar.dart';
import 'package:flutter_user/features/company/company_service.dart';

import '../company_model.dart';
import 'review_tab.dart';

class CompanyDetail extends StatefulWidget {
  const CompanyDetail({super.key, required this.companyID});

  final String companyID;

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail>
    with SingleTickerProviderStateMixin {
  Company? company;
  late bool _loading = true;
  static const imageHeight = 220.0;
  static const profileHeight = 150.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getCompanyByID();
    _tabController = TabController(vsync: this, length: 3);
  }

  getCompanyByID() async {
    final companyRes = await CompanyService.instance.getByID(widget.companyID);
    setState(() {
      company = companyRes;
      _loading = false;
    });
  }

  final List<String> tabs = <String>['Tab 1', 'Tab 2', 'Tab 3'];

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //   ),
        //   title: Text("Company"),
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   centerTitle: true,
        // ),
        appBar: CustomAppBar(
          title: 'Company',
          childHeight: profileHeight,
          height: imageHeight,
          backgroundImage: company?.imageURL ?? '',
          firstIcon: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.phone),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.mail_outline),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(116, 50),
                          ),
                          child: const Text('Follow'),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(width: 0, height: 10),
              Column(
                children: [
                  Text(
                    company?.name ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    company?.size == null ? '0' : company!.size.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(width: 0, height: 10),
              Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const <Widget>[
                      Text("Overview"),
                      Text("Review"),
                      Text("About"),
                    ],
                  ),
                ],
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 5.0,
                color: Colors.white,
              ),
            ),
            child: Container(
              height: profileHeight,
              width: profileHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(company?.imageURL ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: TabBarView(
          controller: _tabController,
          children: [
            const Text("Overview"),
            SingleChildScrollView(
              child: ReviewTabWidget(
                companyID: widget.companyID,
                companyInfo: company?.info,
              ),
            ),
            const Text("About"),
          ],
        ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       Stack(
        //         alignment: Alignment.center,
        //         children: [
        //           Container(
        //             height: 1500,
        //             child: Column(
        //               children: [
        //                 Container(
        //                   child: Image(
        //                     image: NetworkImage(this.company?.imageURL ?? ''),
        //                     fit: BoxFit.cover,
        //                     height: imageHeight,
        //                     width: MediaQuery.of(context).size.width,
        //                   ),
        //                   height: imageHeight,
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.all(10.0),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Row(
        //                         children: [
        //                           OutlinedButton(
        //                             onPressed: () {},
        //                             child: Icon(Icons.phone),
        //                             style: OutlinedButton.styleFrom(
        //                               minimumSize: Size(50, 50),
        //                               shape: CircleBorder(),
        //                             ),
        //                           ),
        //                           OutlinedButton(
        //                             onPressed: () {},
        //                             child: Icon(Icons.mail_outline),
        //                             style: OutlinedButton.styleFrom(
        //                               minimumSize: Size(50, 50),
        //                               shape: CircleBorder(),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                       Row(
        //                         children: [
        //                           OutlinedButton(
        //                             onPressed: () {},
        //                             child: const Text('Follow'),
        //                             style: OutlinedButton.styleFrom(
        //                               minimumSize: Size(116, 50),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 SizedBox(width: 0, height: 10),
        //                 Column(
        //                   children: [
        //                     Text(
        //                       company?.name ?? '',
        //                       style: Theme.of(context).textTheme.titleLarge,
        //                     ),
        //                     Text(
        //                       company?.size == null
        //                           ? '0'
        //                           : company!.size.toString(),
        //                       style: Theme.of(context).textTheme.titleMedium,
        //                     ),
        //                   ],
        //                 ),
        //                 SizedBox(width: 0, height: 10),
        //                 Expanded(
        //                   child: DefaultTabController(
        //                     length: 3,
        //                     child: Column(
        //                       children: [
        //                         TabBar(
        //                           tabs: [
        //                             Text("Overview"),
        //                             Text("Review"),
        //                             Text("About"),
        //                           ],
        //                         ),
        //                         Expanded(
        //                           child: TabBarView(
        //                             children: [
        //                               Text("Overview"),
        //                               ReviewTabWidget(
        //                                 companyID: widget.companyID,
        //                                 companyInfo: company?.info,
        //                               ),
        //                               Text("About"),
        //                             ],
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Positioned(
        //             top: imageHeight - (profileHeight / 2),
        //             child: Container(
        //               height: profileHeight,
        //               width: profileHeight,
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 image: DecorationImage(
        //                   image: NetworkImage(this.company?.imageURL ?? ''),
        //                   fit: BoxFit.cover,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
