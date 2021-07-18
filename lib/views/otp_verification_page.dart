import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:teach2educate/colors.dart';
import 'package:teach2educate/services/otp.dart';

class OtpVerification extends StatefulWidget {
  final ConfirmationResult confirmationResult;
  final String phoneNumber;
  OtpVerification(
      {required this.confirmationResult, required this.phoneNumber});
  @override
  _OtpVerificationState createState() =>
      _OtpVerificationState(phoneNumber: phoneNumber);
}

class _OtpVerificationState extends State<OtpVerification> {
  String phoneNumber;

  TextEditingController textEditingController = TextEditingController();
  late StreamController<ErrorAnimationType> errorController;
  late int timer;
  bool hasError = false;
  String otpString = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late bool loading;
  _OtpVerificationState({required this.phoneNumber});

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    loading = false;
    timer = 60;
    WidgetsBinding.instance!.addPostFrameCallback(startTimer);
  }

  void startTimer(timestamp) {
    timer = 60;
    Timer.periodic(Duration(seconds: 1), (time) {
      if (!mounted) return;
      setState(() {
        timer = timer - 1;
      });
      if (timer == 0) {
        time.cancel();
      }
    });
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
              opacity: loading ? 0.6 : 1,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                body: Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Verify your OTP",
                          style: TextStyle(
                              color: kBlue,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          constraints: BoxConstraints(maxWidth: 500),
                          child: buildOtpFields(context),
                        ),
                        Builder(builder: (context) {
                          return Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Didn't receive the OTP ? \n",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Resend",
                                    style: TextStyle(
                                      color: timer != 0
                                          ? Colors.grey.shade600
                                          : kBlue,
                                      fontWeight: timer != 0
                                          ? FontWeight.w500
                                          : FontWeight.w800,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (timer == 0) {
                                          setState(() {
                                            loading = true;
                                          });
                                          AuthCredential credential =
                                              PhoneAuthProvider.credential(
                                                  verificationId: widget
                                                      .confirmationResult
                                                      .verificationId,
                                                  smsCode: otpString);

                                          await OTPService().signInWithCred(
                                            credential,
                                          );
                                        }
                                      },
                                  ),
                                  timer != 0
                                      ? TextSpan(
                                          text: " in $timer seconds",
                                          style: TextStyle(
                                            color: Colors.deepOrange.shade700,
                                          ),
                                        )
                                      : TextSpan(),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Builder buildOtpFields(BuildContext context) {
    return Builder(builder: (context) {
      return PinCodeTextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
        length: 6,
        animationType: AnimationType.scale,
        autoFocus: true,
        validator: (v) {
          return null;
        },
        cursorColor: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        textStyle: TextStyle(fontSize: 20, height: 1.6),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          activeColor: Color(0xFFb0cbf8).withOpacity(0.7),
          activeFillColor: Color(0xFFb0cbf8).withOpacity(0.5),
          inactiveColor: Color(0xFFb0cbf8).withOpacity(0.7),
          inactiveFillColor: Colors.grey.withOpacity(0.1),
          selectedColor: Color(0xFFb0cbf8).withOpacity(0.7),
          selectedFillColor: Color(0xFFb0cbf8).withOpacity(0.2),
        ),
        onCompleted: (v) async {
          setState(() {
            loading = true;
          });
          AuthCredential credential = PhoneAuthProvider.credential(
              verificationId: widget.confirmationResult.verificationId,
              smsCode: otpString);

          await OTPService().signInWithCred(
            credential,
          );
          setState(() {
            loading = false;
          });
        },
        onChanged: (value) {
          setState(() {
            otpString = value;
          });
        },
        beforeTextPaste: (text) {
          return false;
        },
      );
    });
  }
}
