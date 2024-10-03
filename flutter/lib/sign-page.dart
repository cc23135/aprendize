import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aprendize/colecao_inicial.dart';
import 'package:aprendize/login-page.dart';
import 'colors.dart';
import 'AppStateSingleton.dart';
import 'package:http/http.dart' as http;
import 'components.dart'; 


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  double _tamUsername = 0;
  double _tamNome = 0;
  double _tamSenha = 0;
  double _tamReqSenha = 0;
  double _tamConfirmarSenha = 0;
  bool _isLoading = false;
  double _tamUsernameDuplicado = 0;

  // Instância do ImageService
  final ImageService _imageService = ImageService();

  Future<void> _pickImage() async {
    _toggleLoadingState(true);
    await _imageService.pickImage((formData) async {
      await _imageService.uploadImage(formData);
      _toggleLoadingState(false);
    });
  }

  bool _senhaValida(String senha) {
    bool hasDigits = senha.contains(RegExp(r'[0-9]'));

    return senha.length > 4 && hasDigits;
  }

  Future<bool> _existeUsuario(String username) async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/existeUsuario');
    
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] ?? false;
      } else {
        print('Failed to check user existence: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  void _sigin() async{
    bool loginCorreto = true;

    if (_usernameController.text.isEmpty) {
      setState(() {
        _tamUsername = 15;
      });
      loginCorreto = false;
    } else {
      setState(() {
        _tamUsername = 0; // Esconder mensagem de erro
      });

      final usuarioExiste = await _existeUsuario(_usernameController.text);

      if (usuarioExiste == true) {
        loginCorreto = false;

        setState(() {
          _tamUsernameDuplicado = 15;
        });
      } else{
        _tamUsernameDuplicado = 0;
      }

    }

    if (_nameController.text.isEmpty) {
      setState(() {
        _tamNome = 15; // Mostrar mensagem de erro
      });
      loginCorreto = false;
    } else {
      setState(() {
        _tamNome = 0; // Esconder mensagem de erro
      });
    }

    if (_passwordController.text.isEmpty) {
      loginCorreto = false;
      setState(() {
        _tamSenha = 15; // Mostrar mensagem de erro
        _tamConfirmarSenha = 0;
      });
    } else {
      setState(() {
        _tamSenha = 0; // Esconder mensagem de erro
      });

      if (!_senhaValida(_passwordController.text)) {
        _tamReqSenha = 15; // Mostrar mensagem de erro
        loginCorreto = false;
      } else {
        _tamReqSenha = 0; // Esconder mensagem de erro
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        _tamConfirmarSenha = 15; // Mostrar mensagem de erro
        loginCorreto = false;
      } else {
        _tamConfirmarSenha = 0;
      }
    }

    if (loginCorreto){
      // estabelece conexão com o banco de dados e pergunta se as informações estão corretas, fazer isso depois
      // bool resposta = true;

      String urlImage = AppStateSingleton().userProfileImageUrlNotifier.value;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => colecaoInicialPage(username: _usernameController.text, name: _nameController.text, password: _passwordController.text, urlImagem: urlImage,)),
      );

      // if (resposta){
      //   // define informações do usuário e sua senha
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => colecaoInicialPage()),
      //   );
      // } else{
      //   // nome igual, senha inválida, problema com a imagem, outro erro 
      //   print("Tratar banco de dados");
      // }
    }

    if (loginCorreto) {
      // Estabelece conexão com o banco de dados e pergunta se as informações estão corretas
      bool resposta = true;

      if (resposta) {
        String urlImage = AppStateSingleton().userProfileImageUrlNotifier.value;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  colecaoInicialPage(username: _usernameController.text, name: _nameController.text, password: _passwordController.text, urlImagem: urlImage,)),
        );
      } else {
        print("Tratar banco de dados");
      }
    }
  }

  void _navegarParaLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _onUserNameChange(String text) {
    setState(() {
      _tamUsername = text.isEmpty ? 15 : 0;
    });
  }

  void _onUserNameDuplicadoChange(String text) {
    setState(() {
      _tamUsernameDuplicado = text.isEmpty ? 15 : 0;
    });
  }

  void _onNameChange(String text) {
    setState(() {
      _tamNome = text.isEmpty ? 15 : 0;
    });
  }

  void _onPasswordChange(String text) {
    setState(() {
      _tamSenha = text.isEmpty ? 15 : 0;
    });
  }

  void _onPasswordConfirmChange(String text) {
    setState(() {
      _tamConfirmarSenha = 0;
    });
  }

  void _toggleLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 4.0,
                      ),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: AppStateSingleton().userProfileImageUrlNotifier,
                      builder: (context, imageUrl, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: _isLoading
                              ? null
                              : (imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : AssetImage('assets/images/mona.png'))
                                  as ImageProvider,
                          backgroundColor: AppColors.lightBlackForFooter,
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.white,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.darkPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              onChanged: _onUserNameChange,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Informe o seu Nome de Usuário",
                style: TextStyle(
                    fontSize: _tamUsername,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 189, 54, 44)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Já existe esse usuário!",
                style: TextStyle(
                    fontSize: _tamUsernameDuplicado,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 189, 54, 44)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              onChanged: _onNameChange,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Seu Nome',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Informe o seu nome",
                style: TextStyle(
                    fontSize: _tamNome,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 189, 54, 44)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              onChanged: _onPasswordChange,
              obscureText: true,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Informe sua Senha (min 5 caracteres e 1 número)",
                style: TextStyle(
                    fontSize: _tamReqSenha,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 189, 54, 44)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              onChanged: _onPasswordConfirmChange,
              obscureText: true,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirme sua Senha",
                style: TextStyle(
                    fontSize: _tamConfirmarSenha,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 189, 54, 44)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sigin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPurple,
              ),
              child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: _navegarParaLogin,
              child: Text(
                'Já tem uma conta? Faça login',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
