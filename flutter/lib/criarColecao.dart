import 'package:flutter/material.dart';
import 'colors.dart';

class CriarColecaoPage extends StatefulWidget {
  @override
  _CriarColecaoPageState createState() => _CriarColecaoPageState();
}

class _CriarColecaoPageState extends State<CriarColecaoPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Materia> _materias = [];

  void _adicionarMateria() {
    setState(() {
      _materias.add(Materia(titulo: '', subtitulos: []));
    });
  }

  void _adicionarSubtitulo(int index) {
    setState(() {
      _materias[index].subtitulos.add('');
    });
  }

  void _selecionarImagem() {
    // Lógica para abrir diálogo de seleção de imagem
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
            // Card para adicionar imagem
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
                  child: Icon(Icons.add_a_photo, color: AppColors.white),
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
                          // Título da matéria
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
                                              .subtitulos[subtituloIndex] =
                                          value;
                                    });
                                  },
                                  style: TextStyle(
                                    color: AppColors.lightPurple,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Subtítulo',
                                    hintStyle: TextStyle(
                                      color: AppColors.lightPurple.withOpacity(0.7),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: AppColors.lightPurple.withOpacity(0.5)),
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
                              label: Text('Adicionar Subtítulo', style: TextStyle(color: AppColors.white)),
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
                label: Text('Adicionar Matéria', style: TextStyle(color: AppColors.white)),
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
                onPressed: () {
                  // Lógica para criar coleção
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Criar Coleção',
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo para representar uma matéria
class Materia {
  String titulo;
  List<String> subtitulos;

  Materia({required this.titulo, required this.subtitulos});
}
