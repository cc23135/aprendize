import 'package:aprendize/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para converter a resposta em JSON
import 'AppStateSingleton.dart';

import 'main.dart';
import 'signUp.dart';
import 'colors.dart'; // Certifique-se de importar o arquivo colors.dart

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginService {
  Future<bool> attemptLogin(String username, String senha) async {
   print('----');
    print(username);
    print(senha);
    print('${AppStateSingleton().apiUrl}api/login?username=$username&senha=$senha');
    try {
      final response = await http.get(
        Uri.parse(
            '${AppStateSingleton().apiUrl}api/login?username=$username&senha=$senha'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        if (data['success']) {
          validations().salvarDados(data);
          return true; // Login bem-sucedido
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  double _tamUsername = 0;
  double _tamSenha = 0;
  bool _isLoading = false; 
  bool success = false;

  Future<void> handleLogin() async {
    final username = _usernameController.text;
    final senha = _passwordController.text;

    if (username.isEmpty || senha.isEmpty) {
      setState(() {
        _tamUsername = username.isEmpty ? 15 : 0;
        _tamSenha = senha.isEmpty ? 15 : 0;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try{
      success = await LoginService().attemptLogin(username, senha);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        setState(() {
          _tamUsername = 0;
          _tamSenha = 0;
          _showSnackBar(
              'Nome de usuário ou senha inválidos'); // Exibe o SnackBar diretamente no LoginPageState
        });
      }

      setState(() {
        _isLoading = false; // Termina o carregamento
      });

    }catch(e){
      print(e);
    }
    
  }

  void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: AppColors.white), // Texto branco
          ),
          backgroundColor: AppColors.darkPurple,
        ),
      );
    }

  void _navegarParaSigin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpPage()),
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
                style: TextStyle(color: AppColors.white), // Texto branco
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: AppColors.white),
                  border: const OutlineInputBorder(),
                  errorText: _tamUsername > 0 ? "Informe o username" : null,
                  fillColor: AppColors.black,
                  filled: true,
                ),
                inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ]
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: AppColors.white), // Texto branco
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: AppColors.white),
                  border: const OutlineInputBorder(),
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
                  child: Text(
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
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPurple,
                    minimumSize: const Size(180, 55),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
