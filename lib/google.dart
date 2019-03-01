import 'package:google_sign_in/google_sign_in.dart';

Future<GoogleSignInAuthentication> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  return googleSignInAuthentication;
}
