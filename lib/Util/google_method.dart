import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

void googleSignInProcess(BuildContext context) async {
  if (await _googleSignIn.isSignedIn()) {
    handleSignOut();
  }

  GoogleSignInAccount? googleUser;
  GoogleSignInAuthentication googleSignInAuthentication;
  try {
    googleUser = (await _googleSignIn.signIn());
    if (googleUser != null) {
      googleSignInAuthentication = await googleUser.authentication;
      print(googleSignInAuthentication.accessToken);
    }
  } catch (error) {
    print(error);
  }

  if (await _googleSignIn.isSignedIn()) {
    print(googleUser?.email);
    print(googleUser?.displayName);
    print(googleUser?.photoUrl);
    print(googleUser?.id);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sucess:${googleUser?.email}" ?? "")));

  }
}

Future<void> handleSignOut() => _googleSignIn.disconnect();