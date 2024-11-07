import 'package:aprendize/AppStateSingleton.dart';
import 'package:aprendize/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateStudyDayPage extends StatefulWidget {
  final DateTime selectedDay;
  const CreateStudyDayPage({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  _CreateStudyDayPageState createState() => _CreateStudyDayPageState();
}

class _CreateStudyDayPageState extends State<CreateStudyDayPage> {
  List<TopicData> _allTopics = [];
  List<TopicData> _selectedTopics = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final response = await http.post(
      Uri.parse('${AppStateSingleton().apiUrl}api/getTopicsFromGroups'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'groupIds': AppStateSingleton()
            .collections
            .map((group) => group['idColecao'])
            .toList()
      }),
    );

    if (response.statusCode == 200) {
      final topicsData = json.decode(response.body) as List;
      List<TopicData> topics = topicsData.map((topic) {
        return TopicData(
          topic['idTopico'] as int,
          topic['nome'] as String,
          capa: topic['Materia']['capa'] as String,
          materia: topic['Materia']['nome']
              as String, // Adicionando o nome da matéria
        );
      }).toList();
      setState(() {
        _allTopics = topics;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTopics = _allTopics
        .where((topic) =>
            topic.topic.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Agrupando os tópicos por matéria
    Map<String, List<TopicData>> groupedTopics = {};
    for (var topic in filteredTopics) {
      if (!groupedTopics.containsKey(topic.materia)) {
        groupedTopics[topic.materia] = [];
      }
      groupedTopics[topic.materia]!.add(topic);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.selectedDay.day} de ${DateFormat('MMMM', 'pt_BR').format(widget.selectedDay)}, ${DateFormat('EEEE', 'pt_BR').format(widget.selectedDay)}',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Text(
                        'Selecionar Tópicos',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Pesquisar',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tópicos Disponíveis',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                ),
                // Exibição dos tópicos agrupados por matéria
                ...groupedTopics.entries.map((entry) {
                  String materia = entry.key;
                  List<TopicData> topics = entry.value;

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            // Exibindo o nome da matéria com margem à esquerda
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 8.0),
                              child: Text(
                                materia,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }

                          final topic = topics[index -
                              1]; // Ajustando o índice para ignorar o título da matéria
                          final isSelected = _selectedTopics
                              .any((data) => data.topic == topic.topic);
                          return ListTile(
                            title: Text(topic.topic),
                            trailing: Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected ? Colors.green : null,
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedTopics.removeWhere(
                                      (data) => data.topic == topic.topic);
                                } else {
                                  _selectedTopics.add(topic);
                                }
                              });
                            },
                          );
                        },
                        childCount: topics.length +
                            1, // +1 para incluir o título da matéria
                      ),
                    ),
                  );
                }).toList(),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Tópicos Selecionados',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _selectedTopics.length) {
                        final topicData = _selectedTopics[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          width: MediaQuery.of(context).size.width *
                              0.9, // 90% do container
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.white,
                                  width: 2), // Borda branca
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken,
                                    ),
                                    child: Image.network(
                                      topicData.capa,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF8C52FF)
                                              .withOpacity(0.5),
                                          const Color(0xFF5E17EB)
                                              .withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topicData.topic,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: TextField(
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                labelText: 'Exercícios',
                                                labelStyle: TextStyle(color: Colors.white),
                                                fillColor: Colors.black
                                                    .withOpacity(0.9),
                                                filled: true,
                                                border:
                                                    const OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                              ],
                                              onChanged: (value) {
                                                topicData.exercises =
                                                    int.tryParse(value) ?? 0;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 150,
                                            child: TextField(
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                labelText: 'Tempo (min)',
                                                labelStyle: TextStyle(color: Colors.white),
                                                fillColor: Colors.black
                                                    .withOpacity(0.9),
                                                filled: true,
                                                border:
                                                    const OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                              ],
                                              onChanged: (value) {
                                                topicData.studyTime =
                                                    int.tryParse(value) ?? 0;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    childCount: _selectedTopics.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                      child: Column(children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkPurple, // Cor de fundo
                      ),
                      onPressed: () async {
                        if (_selectedTopics.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Selecione pelo menos um tópico.'),
                            ),
                          );
                          return;
                        }

                        final studyDayData = {
                          'idUsuario': AppStateSingleton()
                              .idUsuario, // Garantir que o idUsuario esteja correto
                          'data': DateFormat('yyyy-MM-dd')
                              .format(widget.selectedDay),
                          'subjects': _selectedTopics.map((topic) {
                            return {
                              'idTopico': topic.idTopico,
                              'exercicios': topic.exercises,
                              'tempoDeEstudo': topic.studyTime == 0 ? int.tryParse('00:00:00.0000000') : topic.studyTime,
                            };
                          }).toList(),
                        };

                        final hasValidSubjects = (studyDayData['subjects'] as List).any((subject) {
                          print(subject['tempoDeEstudo']);
                          return subject['exercicios'] > 0 || subject['tempoDeEstudo'] != int.tryParse('00:00:00.0000000');
                        });

                        if (!hasValidSubjects) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Exercícios ou tempo devem ter um valor'),
                            ),
                          );
                          return;
                        }

                        final response = await http.post(
                          Uri.parse(
                              '${AppStateSingleton().apiUrl}api/criarTarefa'),
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode(studyDayData),
                        );
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Erro ao criar o dia de estudos.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Salvar Dia de Estudos', style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ])),
                ),
              ],
            ),
    );
  }
}

class TopicData {
  final int idTopico;
  final String topic;
  final String capa;
  final String materia;
  int studyTime;
  int exercises;

  TopicData(
    this.idTopico,
    this.topic, {
    required this.capa,
    required this.materia,
    this.studyTime = 0,
    this.exercises = 0,
  });
}
