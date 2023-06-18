import 'package:flutter/material.dart';

import '../user_model.dart';

class BasicInfoForm extends StatefulWidget {
  const BasicInfoForm(
      {Key? key, required this.userInfo, required this.saveInfo})
      : super(key: key);
  final UserInfo userInfo;
  final Function saveInfo;

  @override
  _BasicInfoFormState createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends State<BasicInfoForm> {
  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final occupation = TextEditingController();
  final placeOfEmployment = TextEditingController();
  final website = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstName.text = widget.userInfo.givenname ?? '';
    lastName.text = widget.userInfo.familyname ?? '';
    occupation.text = widget.userInfo.occupation ?? '';
    placeOfEmployment.text = widget.userInfo.location ?? '';
    website.text = widget.userInfo.website ?? '';
  }

  saveInfo(BuildContext context) async {
    UserInfo userInfo = widget.userInfo;
    userInfo.givenname = firstName.value.text;
    userInfo.familyname = lastName.value.text;
    userInfo.website = website.value.text;
    userInfo.location = placeOfEmployment.value.text;
    userInfo.occupation = occupation.value.text;
    await widget.saveInfo(userInfo, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic info'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: firstName,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: lastName,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: occupation,
                decoration: InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your occupation';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: placeOfEmployment,
                decoration: InputDecoration(
                  labelText: 'Place of Employment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your place of employment';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: website,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter a website';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      saveInfo(context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
