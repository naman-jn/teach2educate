import 'package:flutter/material.dart';
import 'package:teach2educate/colors.dart';
import 'package:teach2educate/routes/routers.dart';
import 'package:teach2educate/services/database_service.dart';
import 'package:teach2educate/widget/custom_text_field.dart';

class InitialDetailPage extends StatefulWidget {
  InitialDetailPage({Key? key}) : super(key: key);

  @override
  _InitialDetailPageState createState() => _InitialDetailPageState();
}

class _InitialDetailPageState extends State<InitialDetailPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController roleCtrl = TextEditingController();
  TextEditingController companyCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(controller: nameCtrl, hintText: "Name"),
                  CustomTextField(controller: roleCtrl, hintText: "Role"),
                  CustomTextField(controller: companyCtrl, hintText: "Company"),
                  TextButton(
                      onPressed: () => updateDetails(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: kBlue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateDetails(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await DatabaseService()
          .createNewPassenger(nameCtrl.text, roleCtrl.text, companyCtrl.text);
      Routers.pushNamed("/home");
    }
  }
}
