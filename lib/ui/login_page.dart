import 'package:flutter/material.dart';
import 'package:manajemen_pariwisata/ui/tiket_page.dart';
import '../bloc/login_bloc.dart';
import '../helpers/user_info.dart';
import '../widget/warning_dialog.dart';
import '/ui/registrasi_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          titleTextStyle: TextStyle(
            fontFamily: 'Arial',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            textStyle: const TextStyle(fontFamily: 'Arial'),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _emailTextField(),
                  _passwordTextField(),
                  _buttonLogin(),
                  const SizedBox(height: 30),
                  _menuRegistrasi(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(fontFamily: 'Arial'),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(fontFamily: 'Arial'),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return ElevatedButton(
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text(
              "Login",
              style: TextStyle(fontFamily: 'Arial'),
            ),
      onPressed: _isLoading ? null : _validateAndSubmit,
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      _submit();
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var loginResult = await LoginBloc.login(
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text,
      );

      if (loginResult.code == 200) {
        await UserInfo().setToken(loginResult.token!);
        await UserInfo().setUserID(loginResult.userID!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TiketPage()),
        );
      } else {
        _showErrorDialog("Login gagal, silahkan coba lagi");
      }
    } catch (e) {
      print("Login Error: $e");
      _showErrorDialog("Terjadi kesalahan, silakan coba lagi");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WarningDialog(
        description: message,
      ),
    );
  }

  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue, fontFamily: 'Arial'),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }
}
