import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Adicione esta importação
import 'create_study_day_page.dart'; // Importe a CreateStudyDayPage

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Data do calendário selecionada
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Simulação de tarefas por data
  final Map<DateTime, List<String>> _tasks = {
    DateTime(2024, 8, 26): ['Tarefa 1', 'Tarefa 2'],
    DateTime(2024, 8, 27): ['Tarefa 3'],
    // Adicione mais tarefas conforme necessário
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Calendário
          TableCalendar(
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2025, 1, 1),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // Atualiza o dia focalizado
              });
            },
            locale: 'pt_BR', // Adicione esta linha para definir o locale como português
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Lista de tarefas
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _tasks[_selectedDay] != null
                  ? _tasks[_selectedDay]!.map((task) => ListTile(
                        title: Text(task),
                      )).toList()
                  : [const Text('Nenhuma tarefa para hoje')],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateStudyDayPage(), // Navega para a CreateStudyDayPage
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController _taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: 'Digite a tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    if (_tasks[_selectedDay] != null) {
                      _tasks[_selectedDay]!.add(_taskController.text);
                    } else {
                      _tasks[_selectedDay] = [_taskController.text];
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
