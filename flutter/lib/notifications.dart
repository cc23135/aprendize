import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final userId = AppStateSingleton().idUsuario; 
      final response = await http.get(Uri.parse('${AppStateSingleton().apiUrl}api/getNotifications?userId=$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          notifications = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await http.delete(Uri.parse('${AppStateSingleton().apiUrl}api/deleteNotification?id=$notificationId'),
      );
    } catch (e) {
      print("Erro ao conectar para remover a notificação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(
                  child: Column(
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
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0), 
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationWidget(
                        content: notification['conteudo'],
                        onDismiss: () async {
                          await _deleteNotification(notification['idNotificacao'].toString());
                          setState(() {
                            notifications.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

class NotificationWidget extends StatelessWidget {

  final String content;
  final VoidCallback onDismiss;

  NotificationWidget({
    super.key, 
    required this.content,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0), // Margem entre os cards
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
