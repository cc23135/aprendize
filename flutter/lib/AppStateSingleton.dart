// lib/AppStateSingleton.dart
class AppStateSingleton {
  static final AppStateSingleton _instance = AppStateSingleton._internal();
  factory AppStateSingleton() => _instance;
  AppStateSingleton._internal();

  String ApiUrl = '';
  String userProfileImageUrl = '';
  String userName = '';
  List<String> collections = [];
  String statisticsJson = ''; // Adicione esta linha para armazenar o JSON
}
