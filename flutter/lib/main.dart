import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';
import 'home.dart';
import 'statistics.dart';
import 'ranking.dart';
import 'todasColecoes.dart';
import 'calendar.dart';
import 'notifications.dart';
import 'user.dart';
import 'colors.dart';
import 'AppStateSingleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppStateSingleton();
  appState.apiUrl = "http://localhost:6060/";
  await appState.loadThemeMode();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool>? _loginStatusFuture; 

  @override
  void initState() {
    super.initState();
    _loginStatusFuture = _checkLoginStatus(); 
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? senha = prefs.getString('senha');

    if (username != null && senha != null && username.isNotEmpty && senha.isNotEmpty) {
      return await LoginService().attemptLogin(username, senha);
    }

    return false; 
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppStateSingleton().themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aprendize',
          theme: ThemeData(
            primaryColor: AppColors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.black,
              iconTheme: IconThemeData(color: AppColors.black),
              elevation: 0,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.white,
              selectedItemColor: AppColors.lightPurple,
              unselectedItemColor: AppColors.white.withOpacity(0.6),
            ),
            iconTheme: IconThemeData(color: AppColors.black),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primaryColor: AppColors.black,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.black,
              iconTheme: IconThemeData(color: AppColors.white),
              elevation: 0,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.black,
              selectedItemColor: AppColors.lightPurple,
              unselectedItemColor: AppColors.white.withOpacity(0.6),
            ),
            iconTheme: IconThemeData(color: AppColors.white),
            brightness: Brightness.dark,
          ),
          themeMode: themeMode,
          locale: const Locale('pt', 'BR'), 
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: FutureBuilder<bool>(
            future: _loginStatusFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == true) {
                return const MyHomePage();
              } else {
                return const LoginPage();
              }
            },
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; 
  bool _showNotifications = false;
  bool _showUserPage = false;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const StatisticsPage();
      case 2:
        return const RankingPage();
      case 3:
        return const ColecaoPage();
      case 4:
        return const CalendarPage();
      default:
        return const SizedBox(); 
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
      _showNotifications = false; 
      _showUserPage = false; 
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications, color: AppColors.white),
              onPressed: () {
                setState(() {
                  _showNotifications = true;
                  _showUserPage = false;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showUserPage = true;
                  _showNotifications = false;
                });
              },
              child: ValueListenableBuilder<String>(
                valueListenable: AppStateSingleton().userProfileImageUrlNotifier,
                builder: (context, profileUrl, child) {
                  return CircleAvatar(
                    radius: 16,
                    backgroundImage: profileUrl.isNotEmpty
                        ? NetworkImage(profileUrl)
                        : const AssetImage('../assets/images/mona.png') as ImageProvider,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _showNotifications
          ? NotificationsPage() 
          : _showUserPage
              ? UserPage()
              : _buildPage(_selectedIndex), 
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Estatísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Coleções'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendário'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
