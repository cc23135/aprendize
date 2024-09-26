import 'package:aprendize/AppStateSingleton.dart';
import 'package:aprendize/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateStudyDayPage extends StatefulWidget {
  final DateTime selectedDay;
  const CreateStudyDayPage({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _CreateStudyDayPageState createState() => _CreateStudyDayPageState();
}

class _CreateStudyDayPageState extends State<CreateStudyDayPage> {
  List<SubjectData> _allSubjects = [];
  List<SubjectData> _selectedSubjects = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    final response = await http.post(
      Uri.parse('${AppStateSingleton().apiUrl}api/getSubjectsFromGroups'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'groupIds': AppStateSingleton().collections.map((group) => group['idColecao']).toList()}),
    );

    if (response.statusCode == 200) {
      final subjectsData = json.decode(response.body) as List;
      List<SubjectData> subjects = subjectsData.map((subject) {
        return SubjectData(
          subject['nome'] as String,
          capa: subject['capa'] as String,
        );
      }).toList();
      setState(() {
        _allSubjects = subjects;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _allSubjects
        .where((subject) => subject.subject.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedDay.day} de ${DateFormat('MMMM', 'pt_BR').format(widget.selectedDay)}, ${DateFormat('EEEE', 'pt_BR').format(widget.selectedDay)}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white,),
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
                        'Selecionar Matérias',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        'Matérias Disponíveis',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: filteredSubjects.map((subject) {
                          final isSelected = _selectedSubjects.any((data) => data.subject == subject.subject);
                          return ListTile(
                            title: Text(subject.subject),
                            trailing: Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              color: isSelected ? Colors.green : null,
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSubjects.removeWhere((data) => data.subject == subject.subject);
                                } else {
                                  _selectedSubjects.add(subject);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Matérias Selecionadas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _selectedSubjects.length) {
                        final subjectData = _selectedSubjects[index];

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.9, // 90% do container
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColors.white, width: 2), // Borda branca
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      AppColors.black.withOpacity(0.3),
                                      BlendMode.darken,
                                    ),
                                    child: Image.network(
                                      subjectData.capa,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF8C52FF).withOpacity(0.5),
                                          const Color(0xFF5E17EB).withOpacity(0.5),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subjectData.subject,
                                        style: TextStyle(
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
                                              decoration: InputDecoration(
                                                labelText: 'Exercícios',
                                                fillColor: AppColors.black.withOpacity(0.9),
                                                filled: true,
                                                border: const OutlineInputBorder(),
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(3),
                                              ],
                                              onChanged: (value) {
                                                subjectData.exercises = int.tryParse(value) ?? 0;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 150,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Tempo (min)',
                                                fillColor: AppColors.black.withOpacity(0.9),
                                                filled: true,
                                                border: const OutlineInputBorder(),
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(3),
                                              ],
                                              onChanged: (value) {
                                                subjectData.studyTime = int.tryParse(value) ?? 0;
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
                      return null;
                    },
                    childCount: _selectedSubjects.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Criar Dia de Estudo com as matérias selecionadas: $_selectedSubjects');
                      },
                      child: const Text('Criar'),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
    );
  }
}

class SubjectData {
  final String subject;
  final String capa; 
  int exercises;
  int studyTime;

  SubjectData(this.subject, {required this.capa, this.exercises = 0, this.studyTime = 0});
}
