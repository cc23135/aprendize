import 'dart:convert';

import 'package:aprendize/AppStateSingleton.dart';
import 'package:aprendize/colecaoInfo.dart';
import 'package:aprendize/components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';

class CriarColecaoPage extends StatefulWidget {
  @override
  _CriarColecaoPageState createState() => _CriarColecaoPageState();
}

class _CriarColecaoPageState extends State<CriarColecaoPage> {
  final ImageService _imageService = ImageService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Materia> _materias = [];

  String _imageUrl = ''; // Armazena a URL da imagem carregada
  bool _isLoadingImage = false; // Controla o estado de carregamento da imagem

  void _adicionarMateria() {
    setState(() {
      _materias.add(Materia(titulo: '', subtitulos: [], imageUrl: ''));
    });
  }

  void _adicionarSubtitulo(int index) {
    setState(() {
      _materias[index].subtitulos.add('');
    });
  }

  Future<void> _selecionarImagem() async {
    setState(() {
      _isLoadingImage = true;
    });

    await _imageService.pickImage((formData) async {
      final uploadedImageUrl =
          await _imageService.uploadImage(formData, "", false);
      setState(() {
        _imageUrl = uploadedImageUrl!;
        _isLoadingImage = false;
      });
    });
  }

  Future<void> _selecionarImagemMateria(int index) async {
    setState(() {
      _materias[index].isLoadingImage = true;
    });

    await _imageService.pickImage((formData) async {
      final uploadedImageUrl =
          await _imageService.uploadImage(formData, "", false);
      setState(() {
        _materias[index].imageUrl = uploadedImageUrl!;
        _materias[index].isLoadingImage = false;
      });
    });
  }

  bool _validarCampos() {
    if (_nomeController.text.isEmpty) {
      _mostrarErro('O nome da coleção não pode estar vazio.');
      return false;
    }

    for (int i = 0; i < _materias.length; i++) {
      if (_materias[i].titulo.isEmpty) {
        _mostrarErro('O nome da matéria na posição ${i + 1} está vazio.');
        return false;
      }

      for (int j = 0; j < _materias[i].subtitulos.length; j++) {
        if (_materias[i].subtitulos[j].isEmpty) {
          _mostrarErro('Um tópico na matéria ${i + 1} está vazio.');
          return false;
        }
      }
    }

    return true;
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text('Criar Coleção', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.lightBlackForFooter,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Card para adicionar imagem da coleção
            GestureDetector(
              onTap: _selecionarImagem,
              child: Card(
                color: AppColors.lightBlackForFooter,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: _isLoadingImage
                      ? Center(
                          child:
                              CircularProgressIndicator(color: AppColors.white))
                      : _imageUrl.isNotEmpty
                          ? Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            )
                          : Icon(Icons.add_a_photo, color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Campo para o nome da coleção
            TextField(
              controller: _nomeController,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Nome Coleção',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Campo para a descrição da coleção
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título das matérias
            Text(
              'Matérias',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Lista de matérias e subtópicos
            Column(
              children: _materias.map((materia) {
                int index = _materias.indexOf(materia);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    color: AppColors.lightBlackForFooter,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Seletor de imagem para matéria
                          GestureDetector(
                            onTap: () => _selecionarImagemMateria(index),
                            child: Container(
                              height: 100,
                              width:
                                  double.infinity, // Tamanho total do container
                              decoration: BoxDecoration(
                                color: AppColors.lightBlackForFooter,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.lightPurple
                                      .withOpacity(0.5), // Borda do retângulo
                                  width: 2,
                                ),
                                image: materia.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(materia.imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: materia.imageUrl.isEmpty &&
                                      !materia.isLoadingImage
                                  ? Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: AppColors.white.withOpacity(
                                            0.6), // Ícone quando não há imagem
                                        size: 40,
                                      ),
                                    )
                                  : materia.isLoadingImage
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                          ),
                                        )
                                      : null,
                            ),
                          ),

                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _materias[index].titulo = value;
                              });
                            },
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Título da Matéria',
                              hintStyle: TextStyle(color: AppColors.white),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Lista de subtópicos da matéria
                          Column(
                            children: materia.subtitulos.map((subtitulo) {
                              int subtituloIndex =
                                  materia.subtitulos.indexOf(subtitulo);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _materias[index]
                                          .subtitulos[subtituloIndex] = value;
                                    });
                                  },
                                  style: TextStyle(
                                    color: AppColors.lightPurple,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Tópico',
                                    hintStyle: TextStyle(
                                      color: AppColors.lightPurple
                                          .withOpacity(0.7),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: AppColors.lightPurple
                                              .withOpacity(0.5)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: AppColors.lightPurple),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),

                          // Botão para adicionar subtópico
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => _adicionarSubtitulo(index),
                              icon: Icon(Icons.add, color: AppColors.white),
                              label: Text(
                                  'Adicionar tópico em ordem de dependência',
                                  style: TextStyle(color: AppColors.white)),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.lightBlackForFooter,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Botão para adicionar matéria
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _adicionarMateria,
                icon: Icon(Icons.add, color: AppColors.white),
                label: Text('Adicionar Matéria',
                    style: TextStyle(color: AppColors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.lightBlackForFooter,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botão para criar a coleção
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_validarCampos()) {
                    final collectionData = {
                      'nome': _nomeController.text,
                      'descricao': _descricaoController.text,
                      'linkImagem': _imageUrl,
                      'idCriador': AppStateSingleton().idUsuario,
                      'dataCriacao': DateTime.now().toUtc().toIso8601String(),
                      'materias': _materias.map((materia) {
                        return {
                          'nome': materia.titulo,
                          'capa': materia.imageUrl,
                          'topicos': materia.subtitulos
                              .map((subtitulo) => {
                                    'nome': subtitulo,
                                  })
                              .toList(),
                        };
                      }).toList(),
                    };
                    try {
                      final response = await http.post(
                        Uri.parse(
                            '${AppStateSingleton().apiUrl}api/createCollection'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(collectionData),
                      );

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        final idColecao = data['idColecao']; 
                        print('-----------');
                        print(idColecao);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailsPage(
                              idColecao: idColecao,
                            ),
                          ),
                        );
                      } else {
                        // Erro ao criar a coleção
                        // Adicione lógica para lidar com o erro
                      }
                    } catch (e) {
                      // Lidar com exceções, como problemas de rede
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPurple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32), // Ajuste o padding conforme necessário
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Formato do botão
                  ),
                ),
                child: Text(
                  'Criar Coleção',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Materia {
  String titulo;
  List<String> subtitulos;
  String imageUrl;
  bool isLoadingImage;

  Materia(
      {required this.titulo,
      required this.subtitulos,
      required this.imageUrl,
      this.isLoadingImage = false});
}
