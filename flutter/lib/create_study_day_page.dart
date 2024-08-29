import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateStudyDayPage extends StatefulWidget {
  @override
  _CreateStudyDayPageState createState() => _CreateStudyDayPageState();
}

class _CreateStudyDayPageState extends State<CreateStudyDayPage> {
  List<String> _allSubjects = [
    'Matemática 3',
    'Biologia 2',
    'Física 1',
    'Química 4',
    'História 5',
    'Geografia 3'
  ];

  List<SubjectData> _selectedSubjects = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _allSubjects
        .where((subject) => subject.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dia 34 de Dezembro, Quarta-feira'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Selecionar Matérias',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                Text(
                  'Matérias Disponíveis',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling within this list
                  children: filteredSubjects.map((subject) {
                    final isSelected = _selectedSubjects.any((data) => data.subject == subject);
                    return ListTile(
                      title: Text(subject),
                      trailing: Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? Colors.green : null,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSubjects.removeWhere((data) => data.subject == subject);
                          } else {
                            _selectedSubjects.add(SubjectData(subject));
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  'Matérias Selecionadas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < _selectedSubjects.length) {
                  final subjectData = _selectedSubjects[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                            child: Image.asset(
                              'assets/images/mona.png',
                              fit: BoxFit.cover,
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
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150, // Adjust the width as needed
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Exercícios',
                                        fillColor: Colors.black.withOpacity(0.9),
                                        filled: true,
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        // Allowing numbers from 0 to 100
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      onChanged: (value) {
                                        subjectData.exercises = int.tryParse(value) ?? 0;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 150, // Adjust the width as needed
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Tempo (min)',
                                        fillColor: Colors.black.withOpacity(0.9),
                                        filled: true,
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        // Allowing numbers from 0 to 100
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
                  );
                }
                return null;
              },
              childCount: _selectedSubjects.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Ação ao clicar em "Criar"
                  // Implementar a lógica para criar o dia de estudo aqui
                  print('Criar Dia de Estudo com as matérias selecionadas: $_selectedSubjects');
                },
                child: Text('Criar'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

class SubjectData {
  final String subject;
  int exercises;
  int studyTime;

  SubjectData(this.subject, {this.exercises = 0, this.studyTime = 0});
}
