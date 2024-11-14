import 'dart:convert';
import 'package:aprendize/components.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'colors.dart';
import 'signUp.dart';
import 'AppStateSingleton.dart';
import 'package:http/http.dart' as http;

class colecaoInicialPage extends StatefulWidget {
  final String username;
  final String name;
  final String password;
  final String urlImagem;

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
  Color _iconColor = AppColors.white;
  int? _hoveredIndexCard;
  int? _selectedCardIndex;
  List<Map<String, dynamic>> _collections = [];
  List<Map<String, dynamic>> _filteredCollections = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _pesquisaColecaoController.addListener(_filterCollections);
    _fetchColecoes(); 
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
          .where((collection) => collection['nome'].toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _fetchColecoes() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getColecoes');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _collections = List<Map<String, dynamic>>.from(data['colecoes']);
          _filteredCollections = _collections; 
        });
      } else {
        print('Failed to fetch colecoes: ${response.body}');
        _showSnackbar('Erro ao obter coleções, tente novamente', Colors.red);
      }
    } catch (e) {
      print('Error fetching colecoes: $e');
      _showSnackbar('Erro ao obter coleções, tente novamente', Colors.red);
    }
  }

  Future<void> _escolher() async {
    if (_selectedCardIndex == null) {
      _showSnackbar('Nenhuma coleção foi escolhida', AppColors.darkPurple);
    } else {
      final selectedCollectionId = _collections[_selectedCardIndex!]['idColecao'];
      bool signUpSuccess = await _signUpUser(
        name: widget.name,
        username: widget.username,
        password: widget.password,
        imageUrl: widget.urlImagem,
        collectionId: selectedCollectionId,
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
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  Future<bool> _signUpUser({
    required String name,
    required String username,
    required String password,
    required String imageUrl,
    required int collectionId,
  }) async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/signUp');

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
          'idColecaoInicial': collectionId.toString(),
        }),
      );

      if (response.statusCode == 201) {

        final data = jsonDecode(response.body);
        validations().salvarDados(data);
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
      MaterialPageRoute(builder: (context) => SignUpPage()),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Pesquise uma coleção inicial", style: TextStyle(fontSize: 20, color: AppColors.white)),
              ),
              const SizedBox(height: 10),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    if (_iconColor != AppColors.lightPurple) {
                      _iconColor = Colors.white70;
                    }
                  });
                },
                onExit: (_) {
                  setState(() {
                    if (_iconColor != AppColors.lightPurple) {
                      _iconColor = Colors.white54;
                    }
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
                    hintStyle: TextStyle(color: AppColors.white),
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
                              _selectedCardIndex = index;
                            });
                          },
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _hoveredIndexCard = index;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _hoveredIndexCard = null;
                              });
                            },
                            child: Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(_filteredCollections[index]['linkImagem']),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.lightPurple.withOpacity(0.4),
                                    BlendMode.color,
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
                              child: Container(
                                color: Colors.black.withOpacity(0.5), 
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _filteredCollections[index]['nome'],
                                      style: const TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      "${_filteredCollections[index]['numEstudantes']} Estudantes",
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
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
                  ElevatedButton(
                    onPressed: _voltar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      minimumSize: const Size(215, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: _escolher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkPurple,
                      minimumSize: const Size(215, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Escolher', style: TextStyle(color: Colors.white, fontSize: 18)),
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
