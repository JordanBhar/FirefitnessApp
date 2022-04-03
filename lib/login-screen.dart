import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home-screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  var errorMsg = "";

  //User? user = FirebaseAuth.instance.currentUser;

  bool? isChecked = false;


  Widget _buildTextField({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    required var typeTxt,
    FormFieldValidator<String>? validator
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextFormField(
        controller: typeTxt,
        validator: validator,
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: const Color.fromRGBO(255, 159, 129, 1.0),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.red,
            color: Colors.black
          ),
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () async{

          try {
            if (_key.currentState!.validate()) {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text).then((value) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              })));
            }
            errorMsg = "";
          }on FirebaseAuthException catch(error){
            errorMsg = error.message!;
          }
          setState(() {});
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _key,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(255, 130, 100, 1),
                  Color.fromRGBO(255, 136, 106, 1.0),
                  Color.fromRGBO(255, 138, 108, 1.0),
                  Color.fromRGBO(255, 146, 123, 1.0),
                  Color.fromRGBO(255, 153, 128, 1.0),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ).copyWith(top: 110),
                child: Column(
                  children: [
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'PT-Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      hintText: 'Enter your email',
                      obscureText: false,
                      prefixedIcon: const Icon(Icons.mail, color: Colors.white),
                      typeTxt: emailController,
                        validator: validateEmail
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'PT-Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      hintText: 'Enter your password',
                      obscureText: true,
                      prefixedIcon: const Icon(Icons.lock, color: Colors.white),
                      typeTxt: passwordController,
                      validator: validatePassword
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildLoginButton(),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: Text(
                          errorMsg,
                        style: const TextStyle(
                            color: Color.fromRGBO(246, 6, 6, 1.0),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? formEmail){
  if(formEmail == null || formEmail.isEmpty){
    return 'E-mail address is required.';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}

String? validatePassword(String? formPass){
  if(formPass == null || formPass.isEmpty){
    return 'Password is required.';
  }


  return null;

}

