// rever: sistema de sigin

// criar resposta quando não escolheu card
// criar resposta quando BD retorna false
// substituir snackbar


// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';
import 'colors.dart';
import 'sign-page.dart';
import 'AppStateSingleton.dart';
import 'package:http/http.dart' as http;

class colecaoInicialPage extends StatefulWidget {
  final String username;
  final String name;
  final String password;
  final String urlImagem;

  // Add a constructor to accept the required parameters
  const colecaoInicialPage({
    Key? key,
    required this.username,
    required this.name,
    required this.password,
    required this.urlImagem,
  }) : super(key: key);

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
      _iconColor = _focusNode.hasFocus ? AppColors.lightPurple : Colors.white54;
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


void _escolher() async {
  if (_selectedCardIndex == null) {
    _showSnackbar('Nenhuma coleção foi escolhida', AppColors.darkPurple);
  } else {
    bool signUpSuccess = await _signUpUser(
      name: widget.name,
      username: widget.username,
      password: widget.password,
      imageUrl: widget.urlImagem,
      collectionId: _selectedCardIndex,
    );
    if (signUpSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      _showSnackbar('Erro ao acessar o banco de dados ou criar o user, tente novamente', Colors.red);
    }
  }
}

void _showSnackbar(String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(milliseconds: 1500),
    ),
  );
}

  Future<bool> _signUpUser({
    required String name,
    required String username,
    required String password,
    required String imageUrl,
    int? collectionId,
  }) async {
  final uri = Uri.parse('${AppStateSingleton().ApiUrl}api/signUp');

  try {

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nome': name,
        'username': username,
        'senha': password,
        'linkFotoDePerfil': imageUrl,
        if (collectionId != null) 'idColecaoInicial': collectionId.toString(),
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to sign up: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error signing up user: $e');
    return false;
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
      backgroundColor: AppColors.black,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(34.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logoAprendize.png', height: 70),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Pesquise uma coleção inicial", style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 10),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    if (_iconColor != AppColors.lightPurple)
                      _iconColor = Colors.white70; // Default color when hovered
                  });
                },
                onExit: (_) {
                  setState(() {
                    if (_iconColor != AppColors.lightPurple)
                      _iconColor = Colors.white54; // Default color when not hovered
                  });
                },
                child: TextField(
                  controller: _pesquisaColecaoController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _iconColor,
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                                  image: const AssetImage('assets/images/mona.png'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken,
                                  ),
                                ),
                                border: Border.all(
                                  color: _selectedCardIndex == index
                                      ? AppColors.lightPurple
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
                                        style: const TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        "$index estudante(s)",
                                        style: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _voltar,
                    child: Text('Voltar', style: TextStyle(color: AppColors.black, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      minimumSize: const Size(215, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _escolher,
                    child: const Text('Escolher', style: TextStyle(color: Colors.white, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkPurple,
                      minimumSize: const Size(215, 65),
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
