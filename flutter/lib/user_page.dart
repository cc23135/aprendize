import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para verificar a plataforma
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:aprendize/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aprendize/AppStateSingleton.dart';
import 'components.dart'; // Importa o CustomCard

class ImageService {
  final Dio _dio = Dio();

  Future<void> pickImage(Function(FormData) onImagePicked) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final formData = await _prepareFormData(image);
      onImagePicked(formData);
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

  Future<void> uploadImage(FormData formData) async {
    try {
      final url = '${AppStateSingleton().apiUrl}api/upload-image';
      final response = await _dio.post(url, data: formData);
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
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ImageService _imageService = ImageService();
  bool _isLoading = false;
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();
  String _previousImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _nameController.text = AppStateSingleton().nome; // Inicializa o controlador com o nome atual
    _previousImageUrl = AppStateSingleton().userProfileImageUrlNotifier.value; // Armazena a URL anterior da imagem
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
    // O loading é ativado apenas se uma imagem for escolhida
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _toggleLoadingState(true); // Ativa o loading
      final formData = await _imageService._prepareFormData(image);
      await _imageService.uploadImage(formData);
      _toggleLoadingState(false); // Desativa o loading
    }
  }

  void _toggleLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _toggleTheme() async {
    final newThemeMode =
        AppStateSingleton().themeModeNotifier.value == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;

    AppStateSingleton().themeModeNotifier.value = newThemeMode;
    await _saveThemePreference(newThemeMode == ThemeMode.dark);
  }

  void _saveName() {
    setState(() {
      AppStateSingleton().nome = _nameController.text; // Atualiza o nome no singleton
      _isEditingName = false; // Para o modo de edição
    });
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
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
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
                                          : const AssetImage('assets/images/mona.png'))
                                      as ImageProvider,
                              backgroundColor: themeMode == ThemeMode.dark
                                  ? AppColors.lightBlackForFooter
                                  : AppColors.white,
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
                          child: Icon(Icons.edit,
                              size: 25, color: AppColors.darkPurple),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isEditingName
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centraliza o nome
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5, // 50% da largura
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.lightBlackForFooter,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check, color: AppColors.lightPurple),
                            onPressed: _saveName,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centraliza o nome
                        children: [
                          SizedBox(width: 40), // Adiciona um espaço à esquerda igual ao tamanho do botão
                          Expanded(
                            child: Container(
                              alignment: Alignment.center, // Alinha o texto no centro do Container
                              child: Text(
                                AppStateSingleton().nome,
                                textAlign: TextAlign.center, // Adiciona alinhamento ao texto
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: AppColors.lightPurple),
                            onPressed: () {
                              setState(() {
                                _isEditingName = true; // Ativa o modo de edição
                              });
                            },
                          ),
                        ],
                      ),
                const SizedBox(height: 5),
                Text(
                  'Total de horas estudadas: 21',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Grupos',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: AppStateSingleton().collections.length,
                      itemBuilder: (context, index) {
                        final collection = AppStateSingleton().collections[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CardColecao(
                            title: collection['nome'] ?? 'Título não disponível',
                            subtitle: collection['descricao'] ?? 'Descrição não disponível',
                            imageUrl: collection['linkImagem'] ?? '',
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
