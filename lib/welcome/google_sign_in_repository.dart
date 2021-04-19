import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSignInRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> handleSignIn() async {
    User user;
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }
    var email = user.email;
    var uid = user.uid;
    var databaseID = await loginGoogleUser(email, uid);
    return databaseID;
  }

  Future<dynamic> loginGoogleUser(mail, password) async {
    Map body = {
      'name': mail,
      'password': password,
    };
    var response = await http.post("https://petsyy.herokuapp.com/googleAuth",
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    String id = "";
    if (response.statusCode == 200) {
       id = json.decode(response.body)["id"];
      await Hive.box("IsLogin").put("id", id);
    }
    return id;
  }
}
