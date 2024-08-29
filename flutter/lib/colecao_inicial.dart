// quando digita já retira o aviso pedindo pra consertar
// borda do input muda de cor se errado?

// criar resposta quando BD retorna false

import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'colors.dart';
import 'package:image_picker/image_picker.dart';

import 'sign-page.dart';

class colecaoInicialPage extends StatefulWidget {
  @override
  _colecaoInicialPageState createState() => _colecaoInicialPageState();
}

class _colecaoInicialPageState extends State<colecaoInicialPage> {

  final _pesquisaColecaoController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  Color _iconColor = Colors.white54; // Set initial color to white54

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _iconColor = _focusNode.hasFocus ? Colors.deepPurple[200]! : Colors.white54;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.topCenter,

        child: SingleChildScrollView(

          // define largura
          padding: EdgeInsets.all(34.0),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: <Widget>[

              
              Image.asset('assets/images/logoAprendize.png', height: 70), 

              SizedBox(height: 40),

              Align(
                alignment: Alignment.centerLeft,

                child: Text("Pesquise uma coleção inicial", style: TextStyle(fontSize: 20))
              ),
              
              SizedBox(height: 10),

              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    if (_iconColor != Colors.deepPurple[200]!)
                      _iconColor = Colors.white70; // Default color when hovered
                  });
                },
                onExit: (_) {
                  setState(() {
                    if (_iconColor != Colors.deepPurple[200]!)
                      _iconColor = Colors.white54; // Default color when not hovered
                  });
                },
                child: TextField(
                  controller: _pesquisaColecaoController,
                  focusNode: _focusNode, // Attach the FocusNode
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _iconColor, // Change color based on focus state
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                height: 370, // Set the desired height
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkPurple), // Border color and width
                  borderRadius: BorderRadius.circular(10), // Border radius
                ),

                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      20,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),


                        child: Container(
                          height: 130,
                          width: double.infinity,
                          
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54), // Border color and width
                            borderRadius: BorderRadius.circular(10), // Border radius
                          ),

                          child: Align(
                            alignment: Alignment.centerLeft,

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                

                                children: [
                                  Text(
                                    'Coleção $index',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),

                                  Text("$index estudante(s)")
                                ],

                              )
                            )
                          )


                        ),


                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),


              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  ElevatedButton(
                    // onPressed: _sigin,
                    onPressed: () => {},
                    child: Text('Entrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: Size(215, 65), // Width set to infinity to occupy full width, height set to 60
                      
                      textStyle: TextStyle(fontSize: 18),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set the border radius here
                      ),
                    ),
                  ),

                  ElevatedButton(
                    // onPressed: _sigin,
                    onPressed: () => {},
                    child: Text('Entrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: Size(215, 65), // Width set to infinity to occupy full width, height set to 60
                      
                      textStyle: TextStyle(fontSize: 18),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set the border radius here
                      ),
                    ),
                  ),
                ],
              )



            ]


          )

        )
      ),
    );
  }
}