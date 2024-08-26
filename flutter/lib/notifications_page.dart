import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Lista para armazenar notificações
  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mostrar alerta (opcional)
      // mostrarAlerta(context, 'Alerta', 'Você entrou na página de notificações.');
    });

    // Adiciona notificações de exemplo
    adicionarNotificacao('Atualização Disponível', 'Uma nova atualização está disponível para download.');
    adicionarNotificacao('Mensagem Nova', 'Você tem uma nova mensagem de John Doe.');
    adicionarNotificacao('Novo Comentário', 'Seu post recebeu um novo comentário.');
  }

  void mostrarAlerta(BuildContext context, String titulo, String conteudo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(conteudo),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void adicionarNotificacao(String titulo, String conteudo) {
    setState(() {
      notifications.add({'title': titulo, 'content': conteudo});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            if (notifications.isEmpty) 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.notifications_off, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Não há nenhuma notificação',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else 
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationWidget(
                      title: notification['title']!,
                      content: notification['content']!,
                      onDismiss: () {
                        setState(() {
                          notifications.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onDismiss;

  NotificationWidget({
    required this.title,
    required this.content,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: onDismiss,
        ),
      ),
    );
  }
}
