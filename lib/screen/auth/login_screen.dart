import 'package:flutter/material.dart';
import 'services/login_services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  late Box box1;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetToken(
            formValues: {
              'email': _emailController,
              'password': _passwordController,
            },
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    createBox();
    // Add this line
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata() {
    if (box1.get('email') != null) {
      _emailController.text = box1.get('email');
      _rememberMe = true; // Add this line
    }
    if (box1.get('password') != null) {
      _passwordController.text = box1.get('password');
      _rememberMe = true; // Add this line
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              _Email(_emailController),
              SizedBox(height: 20),
              _Password(_passwordController),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text('Remember me'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  login();
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if (_rememberMe) {
      box1.put('email', _emailController.text);
      box1.put('password', _passwordController.text);
    } else {
      box1.delete('email');
      box1.delete('password');
    }
  }
}

Widget _Email(_emailController) {
  return TextFormField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: 'Email',
      prefixIcon: Icon(Icons.email),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your email';
      }
      return null;
    },
  );
}

Widget _Password(_passwordController) {
  return TextFormField(
    controller: _passwordController,
    obscureText: true,
    decoration: InputDecoration(
      labelText: 'Password',
      prefixIcon: Icon(Icons.lock),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your password';
      }
      return null;
    },
  );
}
