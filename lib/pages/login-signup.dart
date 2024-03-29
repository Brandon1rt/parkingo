import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkingo/pages/admin.dart';
import 'package:parkingo/pages/createaccount.dart';
import 'package:parkingo/pages/main_page.dart';
import 'package:parkingo/pages/map_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _obscurePassword = true;
  bool _loading = false; // Loading state for email/password sign-in
  bool _googleLoading = false; // Loading state for Google sign-in
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      if (!_isMounted) {
        return; // Check if the widget is still mounted
      }

      setState(() {
        _googleLoading = true; // Set loading state for Google sign-in
      });

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (!_isMounted) {
        return; // Check again after the asynchronous operation
      }

      if (googleSignInAccount == null) {
        // User canceled the sign-in
        _showSnackBar('Sign-in canceled');
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null && _isMounted) {
        // User signed in successfully
        _showSnackBar('Signed in as ${user.displayName}');

        // Navigate to BookingPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        _showSnackBar('Sign-in failed');
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      _showSnackBar('Error during sign-in');
    } finally {
      if (_isMounted) {
        setState(() {
          _googleLoading = false; // Reset loading state for Google sign-in
        });
      }
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      if (!_isMounted) {
        return; // Check if the widget is still mounted
      }

      setState(() {
        _loading = true; // Set loading state for email/password sign-in
      });

      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        // Check if username or password is empty
        _showSnackBar('Username and password are required');
        return;
      }

      // Check if the entered credentials are for the admin
      if (usernameController.text.trim() == 'parkingoadmin@admin.com' &&
          passwordController.text == 'parkingo123') {
        // Navigate to the admin page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdminPage(), // Replace 'AdminPage' with your admin page widget
          ),
        );
        return;
      }

      // Attempt normal user authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null && _isMounted) {
        // User signed in successfully
        _showSnackBar('Signed in as ${user.email}');

        // Navigate to BookingPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage(),
          ),
        );
      } else {
        _showSnackBar('Sign-in failed');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Wrong password provided for that user.');
      } else {
        _showSnackBar('Error during sign-in: ${e.message}');
      }
    } catch (error) {
      print('Email/Password Sign-In Error: $error');
      _showSnackBar('Error during sign-in');
    } finally {
      if (_isMounted) {
        setState(() {
          _loading = false; // Reset loading state for email/password sign-in
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Log in",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.amber),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    hintText: 'username',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  hintText: 'password',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        )),
                    child: Text(
                      "Register Now",
                      style: TextStyle(fontSize: 16, color: Colors.amber),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _signInWithEmailAndPassword,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: _loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text("OR"),
              SizedBox(
                height: 12,
              ),
              OutlinedButton(
                onPressed: _handleSignIn,
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
