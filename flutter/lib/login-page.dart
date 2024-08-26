import 'dart:math';

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

  void _login() {
    // Aqui você pode adicionar lógica real de autenticação.
    // Por enquanto, vamos simular o sucesso do login e redirecionar.

     bool loginCorreto = true;

    if (_usernameController.text == ""){
      print("informe o username");
      loginCorreto = false;
    }
    if (_passwordController.text == ""){
      print("Informe uma senha");
      loginCorreto = false;
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


  void _navegarParaSigin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

// sized box está servindo como gap, consertar isso?
// width responsivo 
// botão próximo maior e mais forte


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