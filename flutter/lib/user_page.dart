import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para verificar a plataforma
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Dio _dio = Dio();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _toggleLoadingState(true);
      final formData = await _prepareFormData(image);
      await _uploadImage(formData);
      _toggleLoadingState(false);
    }
  }

  Future<FormData> _prepareFormData(XFile image) async {
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

  Future<void> _uploadImage(FormData formData) async {
    try {
      final response = await _dio.post(
        '${AppStateSingleton().ApiUrl}api/upload-image',
        data: formData,
      );
      if (response.statusCode == 200) {
        AppStateSingleton().userProfileImageUrlNotifier.value =
            response.data['url'];
      } else {
        print('Falha ao enviar a imagem. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar a imagem: $e');
    }
  }

  void _toggleLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _toggleTheme() async {
    final currentThemeMode = AppStateSingleton().themeModeNotifier.value;
    final newThemeMode =
        currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await AppStateSingleton().setThemeMode(newThemeMode);
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
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0,
                      ),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable:
                          AppStateSingleton().userProfileImageUrlNotifier,
                      builder: (context, imageUrl, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: _isLoading
                              ? null
                              : (imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage('assets/images/mona.png'))
                                  as ImageProvider,
                          backgroundColor: Colors.grey.shade800,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
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
            const SizedBox(height: 20),
            const Text(
              'Nobara Kugisaki',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Total de horas estudadas: 184',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: <Widget>[
                    Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      child: const ListTile(
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
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      child: const ListTile(
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
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text('Sair', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _toggleTheme, // Alterna entre temas ao clicar
            ),
          ],
        ),
      ),
    );
  }
}
