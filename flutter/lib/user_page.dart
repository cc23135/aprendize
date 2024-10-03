import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aprendize/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aprendize/AppStateSingleton.dart';
import 'components.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ImageService _imageService = ImageService();
  bool _isLoading = false;
  bool _isEditingName = false;
  bool _isEditingUsername = false;
  bool _isEditingPassword = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _nameController.text = AppStateSingleton().nome;
    _usernameController.text = AppStateSingleton().username;
    _newPasswordController.text = AppStateSingleton().senha; // Define a senha atual no campo
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    AppStateSingleton().themeModeNotifier.value =
        isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _toggleLoadingState(true);
      final formData = await _imageService.prepareFormData(image);
      await _imageService.uploadImage(formData);
      _toggleLoadingState(false);
    }
  }

  void _toggleLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _saveName() {
    setState(() {
      AppStateSingleton().nome = _nameController.text;
      _isEditingName = false;
    });
  }

  void _saveUsername() {
    setState(() {
      AppStateSingleton().username = _usernameController.text;
      _isEditingUsername = false;
    });
  }

  void _saveNewPassword() {
    setState(() {
      AppStateSingleton().senha = _newPasswordController.text; // Salva a nova senha
      _isEditingPassword = false;
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppStateSingleton().themeModeNotifier,
      builder: (context, themeMode, child) {
        return Scaffold(
          backgroundColor: AppColors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                                        : const AssetImage('assets/images/mona.png')) as ImageProvider,
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
                            child: Icon(Icons.edit, size: 25, color: AppColors.darkPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _isEditingName
                      ? _buildEditField(
                          controller: _nameController,
                          onSave: _saveName,
                        )
                      : _buildDisplayField(
                          value: _nameController.text,
                          onEdit: () {
                            setState(() {
                              _isEditingName = true;
                            });
                          },
                        ),
                  _isEditingUsername
                      ? _buildEditField(
                          controller: _usernameController,
                          onSave: _saveUsername,
                        )
                      : _buildDisplayField(
                          value: '@${_usernameController.text}',
                          onEdit: () {
                            setState(() {
                              _isEditingUsername = true;
                            });
                          },
                        ),
                  _buildPasswordField(),
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
                  Container(
                    height: 200,
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
                  const SizedBox(height: 10),
                  IconButton(
                    icon: Transform.rotate(
                      angle: themeMode == ThemeMode.light ? 0 : 3.14159,
                      child: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.wb_sunny
                            : Icons.mode_night,
                        color: AppColors.white,
                        size: 30,
                      ),
                    ),
                    onPressed: _toggleTheme,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Novo valor',
                hintStyle: TextStyle(color: AppColors.lightPurple),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check, color: AppColors.lightPurple),
            onPressed: onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayField({
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
              icon: Icon(Icons.edit, color: AppColors.lightPurple),
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    if (_isEditingPassword) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _newPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Nova Senha',
                  hintStyle: TextStyle(color: AppColors.lightPurple),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 5), // Espaço entre os inputs
            Expanded(
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Confirmação',
                  hintStyle: TextStyle(color: AppColors.lightPurple),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.lightPurple,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.check, color: AppColors.lightPurple),
              onPressed: _saveNewPassword,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Center(
              child: Text(
                _isPasswordVisible ? AppStateSingleton().senha : '******',
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.lightPurple,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.lightPurple),
                    onPressed: () {
                      setState(() {
                        _isEditingPassword = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = AppStateSingleton().themeModeNotifier.value == ThemeMode.dark;
    AppStateSingleton().themeModeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    prefs.setBool('isDarkMode', !isDarkMode);
  }
}
