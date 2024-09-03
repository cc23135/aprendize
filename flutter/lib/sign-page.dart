// senha com mais de um dígito, pelo menos uma letra maiúscula, caracter especial e 5 dígitos
// > necessita de um sp no banco de dados

// usuário com dígitos mínimos
// > SP

// borda do input muda de cor se errado?

// criar resposta quando BD retorna false
// corrigir foto


import 'package:aprendize/login-page.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aprendize/colecao_inicial.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  
  double _tamUsername = 0;
  double _tamSenha = 0;
  double _tamReqSenha = 0;
  double _tamConfirmarSenha = 0;


  String _caminhoDaImagem = "";


  bool _senhaValida(String senha) {
    return true;
    // todo
    bool hasUppercase = senha.contains(RegExp(r'[A-Z]'));
    bool hasDigits = senha.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return senha.length > 4 && hasUppercase && hasDigits && hasSpecialCharacters;
  }


  void _sigin() {
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
        _tamConfirmarSenha = 0;
      });

    } else{
      setState(() {
        _tamSenha = 0;
      });

      if (!_senhaValida(_passwordController.text)){
        _tamReqSenha = 15;
        loginCorreto = false;
      } else
        _tamReqSenha = 0;
        

      if (_passwordController.text != _confirmPasswordController.text){
        _tamConfirmarSenha = 15;
        loginCorreto = false;
      } else
        _tamConfirmarSenha = 0;

    }


    if (loginCorreto){
      
      // estabelece conexão com o banco de dados e pergunta se as informações estão corretas
      bool resposta = true;

      if (resposta){
        // define informações do usuário e sua senha
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => colecaoInicialPage()),
        );
      } else{
        // nome igual, senha inválida, problema com a imagem, outro erro 
        print("Tratar banco de dados");
      }
    }

  }
  
  void _navegarParaLogin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

    
  void _alterarFoto() async {
    final ImagePicker _picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _caminhoDaImagem = image.path;
        print(_caminhoDaImagem);
      });
    } else {
        // Handle the case when the user cancels the picker
        setState(() {
        _caminhoDaImagem = "";
        });
        print('No image selected.');

      // COLOCAR AVISO GRÁFICO
    }
  }

  void _onUserNameChange(String text){
    if (text == "")
      setState(() {
        _tamUsername = 15; 
      });
    else
      setState(() {
        _tamUsername = 0; 
      });
  }

  void _onPasswordChange(String text){
    if (text == "")
      setState(() {
        _tamSenha = 15; 
      });
      
    else
      setState(() {
        _tamSenha = 0; 
      });
  }

  void _onPasswordConfirmChange(String text){
    setState(() {
      _tamConfirmarSenha = 0;
    });
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
              Image.asset('assets/images/logoAprendize.png', height: 70), 

              SizedBox(height: 20),


              // container da foto
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0), // Match the border radius of ClipRRect
                  border: Border.all(
                    color: const Color.fromARGB(255, 79, 59, 255), // Border color
                    width: 3.0, // Border width
                  ),
                ),

                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0), // Match the border radius of BoxDecoration
                      child: Stack(
                        children: [
                          // Background color
                          Container(
                            color: Colors.grey[300], // Background color (fallback color)
                            height: 130.0, // Fixed height of the image
                            width: 130.0, // Fixed width of the image
                          ),
                          // Image with fallback
                          Image.asset(
                            // _caminhoDaImagem
                            'assets/images/mona.png', // Path to your image
                            height: 130.0, // Fixed height of 130px
                            width: 130.0, // Fixed width of 130px
                            fit: BoxFit.cover, // Scale the image to cover the entire space while maintaining aspect ratio
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback in case of an error loading the image
                              return Container(
                                color: Colors.grey[300], // Background color for the error case
                                height: 130.0, // Same size as the image
                                width: 130.0, // Same size as the image
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Button in the top-right corner
                    Positioned(
                      right: -5, 
                      top: -5, 
                      child: Container(

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.darkPurple, // Background color of the button
                          border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          )
                        ),

                        child: IconButton(
                          icon: Icon(Icons.edit, color: AppColors.white), // Icon for the button
                          onPressed: _alterarFoto,
                          padding: EdgeInsets.all(8.0), // Padding around the icon
                        ),
                      ),
                    ),
                  ],
                )
              ),

              SizedBox(height: 20),

              TextField(
                controller: _usernameController,
                onChanged: _onUserNameChange,
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
                onChanged: _onPasswordChange,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),

              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: 
                    Text("Informe a senha", style: TextStyle(fontSize: _tamSenha, fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 189, 54, 44))),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: 
                    Text("A senha deve conter mais de 4 dígitos, uma letra maiúscula, um número e um caracter especial(ex.: !@#)", style: TextStyle(fontSize: _tamReqSenha, fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 189, 54, 44))),
                  )
                ],
              ),

              SizedBox(height: 10),

              TextField(
                controller: _confirmPasswordController,
                onChanged: _onPasswordConfirmChange,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
                            
              Align(
                alignment: Alignment.centerLeft,
                child: Text("As senhas não conferem", style: TextStyle(fontSize: _tamConfirmarSenha, fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 189, 54, 44))),
              ),


              SizedBox(height: 20,),

              MouseRegion(
                cursor: SystemMouseCursors.click, // Change the cursor to a pointer when hovering
                child: GestureDetector(
                  onTap: _navegarParaLogin,
                  child: Text(
                    'Já possui uma conta? Faça o login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 60),

              ElevatedButton(
                onPressed: _sigin,
                child: Text('Entrar'),
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