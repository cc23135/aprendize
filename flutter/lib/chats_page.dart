import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // Controle do texto de pesquisa
  final TextEditingController _searchController = TextEditingController();

  // Lista de chats (exemplo de dados)
  final List<Chat> _chats = [
    Chat(title: 'Chat com João', students: 5, newMessages: 3),
    Chat(title: 'Grupo de Estudo', students: 20, newMessages: 0),
    Chat(title: 'Projeto de Trabalho', students: 4, newMessages: 1),
    Chat(title: 'Discussão de Código', students: 10, newMessages: 2),
  ];

  // Função para filtrar chats com base no texto de pesquisa
  List<Chat> get _filteredChats {
    final query = _searchController.text.toLowerCase();
    return _chats.where((chat) {
      return chat.title.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Título e botão para criar chat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Suas Coleções',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Ação ao clicar no botão para criar um chat
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Lista de cards de chats (Não filtrados)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Remove a rolagem da lista
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(chat.title),
                      subtitle: Text('${chat.students} estudantes'),
                      trailing: chat.newMessages > 0
                          ? Stack(
                              children: <Widget>[
                                Icon(Icons.message, color: Colors.grey),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 20,
                                      maxHeight: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${chat.newMessages}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Título para pesquisar chats
              Text(
                'Pesquisar Chats',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Campo de pesquisa
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Digite o nome do chat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),
              // Lista de chats filtrados
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Remove a rolagem da lista
                itemCount: _filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = _filteredChats[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(chat.title),
                      subtitle: Text('${chat.students} estudantes'),
                      trailing: chat.newMessages > 0
                          ? Stack(
                              children: <Widget>[
                                Icon(Icons.message, color: Colors.grey),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 20,
                                      maxHeight: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${chat.newMessages}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modelo para representar um chat
class Chat {
  Chat({
    required this.title,
    required this.students,
    required this.newMessages,
  });

  final String title;
  final int students;
  final int newMessages;
}
