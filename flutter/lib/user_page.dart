import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para verificar a plataforma
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http; // Importa o http
import 'package:aprendize/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aprendize/AppStateSingleton.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Dio _dio = Dio();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Carregar tema ao iniciar
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    AppStateSingleton().themeModeNotifier.value =
        isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      final url = '${AppStateSingleton().ApiUrl}api/upload-image';
      if (kIsWeb) {
        final response = await _dio.post(url, data: formData);
        if (response.statusCode == 200) {
          AppStateSingleton().userProfileImageUrlNotifier.value =
              response.data['url'];
        } else {
          print('Falha ao enviar a imagem. Status code: ${response.statusCode}');
        }
      } else {
        // Usar http para mobile
        final request = http.MultipartRequest('POST', Uri.parse(url))
          ..files.add(await http.MultipartFile.fromPath('image', formData.fields.first.value));
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          AppStateSingleton().userProfileImageUrlNotifier.value =
              responseData['url'];
        } else {
          print('Falha ao enviar a imagem. Status code: ${response.statusCode}');
        }
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
    final newThemeMode = AppStateSingleton().themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    AppStateSingleton().themeModeNotifier.value = newThemeMode;
    await _saveThemePreference(newThemeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppStateSingleton().themeModeNotifier,
      builder: (context, themeMode, child) {
        return Scaffold(
          backgroundColor: AppColors.black,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
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
                            color: AppColors.white,
                            width: 4.0,
                          ),
                        ),
                        child: ValueListenableBuilder<String>(
                          valueListenable: AppStateSingleton().userProfileImageUrlNotifier,
                          builder: (context, imageUrl, child) {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage: _isLoading
                                  ? null
                                  : (imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : AssetImage('assets/images/mona.png'))
                                      as ImageProvider,
                              backgroundColor: themeMode == ThemeMode.dark
                                  ? AppColors.lightBlackForFooter // Cor para o modo escuro
                                  : AppColors.white, // Cor para o modo claro
                              child: _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                      ),
                                    )
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
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.white,
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: AppColors.darkPurple
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Nobara Kugisaki',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Total de horas estudadas: 184',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: ListView(
                      children: <Widget>[
                        Card(
                          color: AppColors.darkPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColors.white, width: 1),
                          ),
                          child: ListTile(
                            title: Text(
                              'Unicamp - COMVEST',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '1.234 Estudantes',
                              style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                            ),
                            trailing: Icon(Icons.group, color: AppColors.white),
                          ),
                        ),
                        Card(
                          color: AppColors.darkPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColors.white, width: 1),
                          ),
                          child: ListTile(
                            title: Text(
                              'ITA',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '1.234 Estudantes',
                              style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                            ),
                            trailing: Icon(Icons.group, color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPurple,
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
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.white,
                    size: 30,
                  ),
                  onPressed: _toggleTheme,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
