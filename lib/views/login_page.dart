import 'package:flutter/material.dart';
import 'package:teach2educate/colors.dart';
import 'package:teach2educate/services/otp.dart';
import 'package:teach2educate/widget/phone_textField.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          color: kGrey1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: loading,
              child: Opacity(
                opacity: loading ? 0.5 : 1,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: formKey,
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 30,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Sign in",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 40),
                              PhoneTextField(phoneNumber: phoneNumber),
                              SizedBox(height: 30),
                              Builder(
                                builder: (context) => TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        await OTPService().sendOTP(
                                            "+91${phoneNumber.text}", context);
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        backgroundColor: kBlue,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15)),
                                    child: Container(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "GET OTP",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            loading ? Center(child: CircularProgressIndicator()) : Container()
          ],
        ),
      ),
    );
  }
}
