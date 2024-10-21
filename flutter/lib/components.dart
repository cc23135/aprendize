import 'package:aprendize/colecao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para verificar a plataforma
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:aprendize/AppStateSingleton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CardColecao extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int idColecao;

  const CardColecao({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.idColecao,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
    cursor: SystemMouseCursors.click, // Defina o cursor como ponteiro
    child: GestureDetector(
      onTap: () {
      // Aqui você pode adicionar a navegação para a página de detalhes do chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailsPage(
            idColecao: this.idColecao, // Substitua pelo ID que você deseja passar
          ),
        ),
      );
    },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF8C52FF).withOpacity(0.8), const Color(0xFF5E17EB).withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Content on top of image and gradient
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Color(0x80000000), // 50% opacity black
                          blurRadius: 4.45,
                          offset: Offset(0, 2), // Ajuste a posição da sombra conforme necessário
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), 
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          color: Color(0x80000000), // 50% opacity black
                          blurRadius: 4.45,
                          offset: Offset(0, 2), // Ajuste a posição da sombra conforme necessário
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    )
    );
  }
}

class ImageService {
  final Dio _dio = Dio();

  Future<void> pickImage(Function(FormData) onImagePicked) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final formData = await prepareFormData(image);
      onImagePicked(formData);
    }
  }

  Future<FormData> prepareFormData(XFile image) async {
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      return FormData.fromMap({
        'image': MultipartFile.fromBytes(bytes, filename: image.name),
      });
    } else {
      return FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: image.name),
      });
    }
  }

  Future<void> uploadImage(FormData formData, String username) async {
  try {
    final url = '${AppStateSingleton().apiUrl}api/upload-image';
    formData.fields.add(MapEntry('username', username));
    
    final response = await _dio.post(url, data: formData);
    if (response.statusCode == 200) {
      AppStateSingleton().userProfileImageUrlNotifier.value =
          response.data['url'];
          print(AppStateSingleton().userProfileImageUrlNotifier.value);
    } else {
      print('Falha ao enviar a imagem. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao enviar a imagem: $e');
  }
  }
}



class validations{
  bool senhaValida(String senha) {
    bool hasDigits = senha.contains(RegExp(r'[0-9]'));

    return senha.length > 4 && hasDigits;
  }

  Future<bool> existeUsuario(String username) async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/existeUsuario');
    
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] ?? false;
      } else {
        print('Failed to check user existence: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  void salvarDados(Map<String, dynamic> data) async { 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', data['user']['username']);
    await prefs.setString('senha', data['user']['senha']);
  
    AppStateSingleton().idUsuario = data['user']['idUsuario'];
    AppStateSingleton().username = data['user']['username'];
    AppStateSingleton().nome = data['user']['nome']; 
    AppStateSingleton().senha = data['user']['senha']; 
    AppStateSingleton().userProfileImageUrlNotifier.value = data['user']['linkFotoDePerfil'];
    AppStateSingleton().collections = List<Map<String, dynamic>>.from(data['colecoes']);
  }
}