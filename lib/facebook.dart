import 'package:flutter_facebook_login/flutter_facebook_login.dart';

Future<FacebookLoginResult> signInWithFacebook() async {
  final facebookLogin = FacebookLogin();
  final facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
  return facebookLoginResult;
}
