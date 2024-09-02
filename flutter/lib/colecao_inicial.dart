// criar resposta quando não escolheu card
// criar resposta quando BD retorna false
// substituir snackbar


// import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'colors.dart';
import 'sign-page.dart';

class colecaoInicialPage extends StatefulWidget {
  @override
  _colecaoInicialPageState createState() => _colecaoInicialPageState();
}

class _colecaoInicialPageState extends State<colecaoInicialPage> {

  final _pesquisaColecaoController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Color _iconColor = Colors.white54; // Set initial color to white54

  int? _hoveredIndexCard; // To keep track of which card is hovered
  int? _selectedCardIndex; // To keep track of the selected card
  int? _idColecaoSelecionado; 

  List<String> _collections = List.generate(20, (index) => 'Coleção $index');
  List<String> _filteredCollections = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _filteredCollections = _collections; // Initially, show all collections
    _pesquisaColecaoController.addListener(_filterCollections);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _pesquisaColecaoController.removeListener(_filterCollections);
    _pesquisaColecaoController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _iconColor = _focusNode.hasFocus ? AppColors.lightPurple! : Colors.white54;
    });
  }

  void _filterCollections() {
    final query = _pesquisaColecaoController.text.toLowerCase();
    setState(() {
      _filteredCollections = _collections
          .where((collection) => collection.toLowerCase().contains(query))
          .toList();
    });
  }

  void _escolher() {
    if (_selectedCardIndex == null) {
      // Inform the user that no collection was selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhuma coleção foi escolhida', style: TextStyle(color: Colors.white),),

          backgroundColor: AppColors.darkPurple,
          duration: Duration(milliseconds: 1500), // Duração de exibição da SnackBar
        ),
      );


    } else {
      bool resposta = true; // Simulate the response from the database

      if (resposta) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        // lidar com banco de dados
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao acessar o banco de dados, tente novamente', 
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          
          duration: Duration(milliseconds: 1500), // Duração de exibição da SnackBar
            
          ),
        );
      }
    }
  }

  void _voltar() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(34.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logoAprendize.png', height: 70),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Pesquise uma coleção inicial", style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 10),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    if (_iconColor != AppColors.lightPurple!)
                      _iconColor = Colors.white70; // Default color when hovered
                  });
                },
                onExit: (_) {
                  setState(() {
                    if (_iconColor != AppColors.lightPurple!)
                      _iconColor = Colors.white54; // Default color when not hovered
                  });
                },
                child: TextField(
                  controller: _pesquisaColecaoController,
                  focusNode: _focusNode,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _iconColor,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 380,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkPurple, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      _filteredCollections.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCardIndex = index; // Update selected card index
                              _idColecaoSelecionado = 2; // ARRUMAR PRO BD
                            });
                          },
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _hoveredIndexCard = index; // Set the hovered index
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _hoveredIndexCard = null; // Clear the hovered index
                              });
                            },
                            child: Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/mona.png'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken,
                                  ),
                                ),
                                border: Border.all(
                                  color: _selectedCardIndex == index
                                      ? AppColors.lightPurple!
                                      : (_hoveredIndexCard == index ? Colors.white70 : Colors.white54),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _filteredCollections[index],
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        "$index estudante(s)",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                    onPressed: _voltar,
                    child: Text('Voltar', style: TextStyle(color: AppColors.black, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      minimumSize: Size(215, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _escolher,
                    child: Text('Escolher', style: TextStyle(color: Colors.white, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkPurple,
                      minimumSize: Size(215, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
