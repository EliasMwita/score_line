import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:soccersphere/screens/homePage.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _State createState() => _State();
}

class _State extends State<LoginForm> {
  final _Email = TextEditingController();
  final _Password = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            child: Container(
              width: 355,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(50),
                  ),
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Soccer App',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  SizedBox(
                    width: 340,
                    height: 50,
                    child: TextField(
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Email address',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter email address',
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      controller: _Email,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),

                  SizedBox(
                    width: 340,
                    height: 50,
                    child: TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      controller: _Password,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        activeColor: Colors.green, // Set the active color
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  // Button for sign in
                  SizedBox(
                    width: 340,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(335, 60),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const MyHomePage(title: '')));
                        }),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),

                  Container(
                    alignment: Alignment.centerRight, // Align to the left
                    child: GestureDetector(
                      onTap: () {},
                      child: const SizedBox(
                        width: 340,
                        height: 50,
                        child: Text(
                          'Forgotten your password?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
