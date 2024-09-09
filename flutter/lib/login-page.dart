// borda do input muda de cor se errado?

// criar resposta quando BD retorna false

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'colors.dart';
import 'package:image_picker/image_picker.dart';

import 'sign-page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


  double _tamUsername = 0;
  double _tamSenha = 0;

  // void _showSnackBar(String message) {

  Future<void> _login() async {
    // Aqui você pode adicionar lógica real de autenticação.
    // Por enquanto, vamos simular o sucesso do login e redirecionar.

     bool loginCorreto = true;

    if (_usernameController.text == ""){
      setState(() {
        _tamUsername = 15; // Hide the username text
      });

      loginCorreto = false;
    } else{
      setState(() {
        _tamUsername = 0; // Hide the username text
      });
    }
    

    if (_passwordController.text == ""){
      loginCorreto = false;

      setState(() {
        _tamSenha = 15;
      });

    } else{
      setState(() {
        _tamSenha = 0;
      });
    }

    if (loginCorreto){
      // estabelece conexão com o banco de dados e pergunta se as informações estão corretas
      bool resposta = true;




      if (resposta){
        // define informações do usuário e sua senha
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else
        print("Tratar banco de dados");
    }

  }



  

Future<void> _loginNoBD() async {
  final username = _usernameController.text;
  final password = _passwordController.text;

  if (username.isNotEmpty && password.isNotEmpty) {
    final dio = Dio(); // Create an instance of Dio

    try {
      final response = await dio.post(
        kIsWeb ? 'http://localhost:6060/api/login' : 'http://localhost:6060/api/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        bool loginSuccess = responseData['success'];

        if (loginSuccess) {
          // Navigate to the home page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          // Show error message
          _showErrorSnackBar('Invalid username or password');
        }
      } else {
        // Show error message for server error
        _showErrorSnackBar('Server error, please try again later');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      _showErrorSnackBar('An error occurred: $e');
    }
  } else {
    // Handle empty username or password
    _showErrorSnackBar('Username and password cannot be empty');
  }
}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}




  void _navegarParaSigin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

// width responsivo 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.topCenter,

        child: SingleChildScrollView(

          // define largura
          padding: EdgeInsets.all(26.0),
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: <Widget>[
              SizedBox(height: 50),

              Image.asset('assets/images/logoAprendize.png', height: 130), 

              SizedBox(height: 65),

              TextField(
                controller: _usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Informe o username", style: TextStyle(fontSize: _tamUsername, fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 189, 54, 44))),
              ),

              SizedBox(height: 10),

              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Informe a senha", style: TextStyle(fontSize: _tamSenha, fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 189, 54, 44))),
              ),

              SizedBox(height: 20,),

              
              MouseRegion(
                cursor: SystemMouseCursors.click, // Change the cursor to a pointer when hovering
                child: GestureDetector(
                  onTap: _navegarParaSigin,
                  child: Text(
                    'Não possui conta? Cadastre-se',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 70),


              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                   minimumSize: Size(180, 55), // Width set to infinity to occupy full width, height set to 60
                   
                   textStyle: TextStyle(fontSize: 18),

                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10), // Set the border radius here
                   ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}