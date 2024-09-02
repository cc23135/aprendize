import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Para verificar a plataforma
import 'package:flutter/foundation.dart' show kIsWeb; // Verificar se é web
import 'AppStateSingleton.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Dio _dio = Dio(); // Instância do Dio

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        // Web
        final bytes = await image.readAsBytes(); // Lê os bytes da imagem
        final formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(bytes, filename: image.name),
        });
        await _uploadImageWeb(formData);
      } else {
        // Mobile
        final imageFile = image.readAsBytes(); // Para mobile
        final formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(await imageFile, filename: image.name),
        });
        await _uploadImageMobile(formData);
      }
    }
  }

  Future<void> _uploadImageWeb(FormData formData) async {
    try {
      final response = await _dio.post(
        'http://localhost:6060/api/upload-image',
        data: formData,
      );

      if (response.statusCode == 200) {
        print('Upload bem-sucedido: ${response.data}');
        setState(() {
          AppStateSingleton().userProfileImageUrl = response.data['url']; // Atualize a URL conforme necessário
        });
      } else {
        print('Falha ao enviar a imagem. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar a imagem: $e');
    }
  }

  Future<void> _uploadImageMobile(FormData formData) async {
    try {
      final response = await _dio.post(
        'http://localhost:6060/api/upload-image',
        data: formData,
      );

      if (response.statusCode == 200) {
        print('Upload bem-sucedido: ${response.data}');
        setState(() {
          AppStateSingleton().userProfileImageUrl = response.data['url']; // Atualize a URL conforme necessário
        });
      } else {
        print('Falha ao enviar a imagem. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar a imagem: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AppStateSingleton().userProfileImageUrl.isNotEmpty
                        ? NetworkImage(AppStateSingleton().userProfileImageUrl)
                        : AssetImage('assets/images/mona.png') as ImageProvider,
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Nome do usuário
            Text(
              'Nobara Kugisaki',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Total de horas estudadas: 184',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 30),
            // Container com cards
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListView(
                  children: <Widget>[
                    Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      child: ListTile(
                        title: Text(
                          'Unicamp - COMVEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '1.234 Estudantes',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(Icons.group, color: Colors.white),
                      ),
                    ),
                    Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      child: ListTile(
                        title: Text(
                          'ITA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '1.234 Estudantes',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(Icons.group, color: Colors.white),
                      ),
                    ),
                    // Adicione mais cartões conforme necessário
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Botão de logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: Text('Sair', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
