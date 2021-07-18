import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teach2educate/routes/routers.dart';
import 'package:teach2educate/services/database_service.dart';
import 'package:teach2educate/views/otp_verification_page.dart';

class OTPService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> signInWithCred(AuthCredential authCred) async {
    try {
      UserCredential userCredential = await auth.signInWithCredential(authCred);
      if (userCredential.user != null) {
        print(
            "uid:::  " + userCredential.user!.uid + " logged in successfully");
        bool? isNewPassenger = await DatabaseService().isNewPassenger();
        isNewPassenger!
            ? Routers.pushNamed('/initial')
            : Routers.pushNamed('/home');
        return "Successfully SignedIn";
      } else {
        print("user returned null from credential");

        return "User Null from Cred";
      }
    } catch (e) {
      print("exception in signinwithcred $e");
      return e.toString();
    }
  }

  Future sendOTP(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      ConfirmationResult confirmationResult =
          await auth.signInWithPhoneNumber(phoneNumber);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerification(
                    confirmationResult: confirmationResult,
                    phoneNumber: phoneNumber,
                  )));
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
    }
  }
}
