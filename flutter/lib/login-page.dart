// borda do input muda de cor se errado?

// criar resposta quando BD retorna false

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para converter a resposta em JSON

import 'main.dart';
import 'sign-page.dart';
import 'colors.dart'; // Certifique-se de importar o arquivo colors.dart

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  double _tamUsername = 0;
  double _tamSenha = 0;
  bool _isLoading = false; // Variável para gerenciar o estado de carregamento

  // Função para realizar o login
  // Future<void> _login() async {
  //   final nome = _usernameController.text;
  //   final senha = _passwordController.text;

  //   if (nome.isEmpty || senha.isEmpty) {
  //     setState(() {
  //       _tamUsername = nome.isEmpty ? 15 : 0;
  //       _tamSenha = senha.isEmpty ? 15 : 0;
  //     });
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true; // Inicia o carregamento
  //   });

  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://localhost:6060/api/login?nome=$nome&senha=$senha'),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       if (data['success']) {
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => MyHomePage()),
  //         );
  //       } else {
  //         // Tratar falha no login
  //         setState(() {
  //           _tamUsername = 0;
  //           _tamSenha = 0;
  //           _showSnackBar('Nome de usuário ou senha inválidos');
  //         });
  //       }
  //     } else {
  //       // Tratar erro de comunicação com a API
  //       _showSnackBar('Erro ao conectar com o servidor');
  //     }
  //   } catch (e) {
  //     // Tratar exceções
  //     _showSnackBar('Erro ao conectar com o servidor');
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Termina o carregamento
  //     });
  //   }

  //   if (loginCorreto){
  //     // estabelece conexão com o banco de dados e pergunta se as informações estão corretas
  //     bool resposta = true;




  //     if (resposta){
  //       // define informações do usuário e sua senha
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => MyHomePage()),
  //       );
  //     } else
  //       print("Tratar banco de dados");
  //   }

  // }



  

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              Image.asset('assets/images/logoAprendize.png', height: 130),
              const SizedBox(height: 65),
              TextField(
                controller: _usernameController,
                style: TextStyle(color: Colors.white), // Texto preto
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  errorText: _tamUsername > 0 ? "Informe o username" : null,
                  fillColor: AppColors.black,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white), // Texto preto
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  errorText: _tamSenha > 0 ? "Informe a senha" : null,
                  fillColor: AppColors.black,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _navegarParaSigin,
                  child: const Text(
                    'Não possui conta? Cadastre-se',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lightPurple,
                  ),
                )
              else
                ElevatedButton(
                  // onPressed: _login,
                  onPressed: () => {},
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPurple,
                    minimumSize: const Size(180, 55),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
