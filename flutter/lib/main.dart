import 'package:aprendize/login-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page.dart';
import 'statistics_page.dart';
import 'ranking_page.dart';
import 'chats_page.dart';
import 'calendar_page.dart';
import 'notifications_page.dart';
import 'user_page.dart';
import 'colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AppStateSingleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppStateSingleton();
  appState.apiUrl = "http://localhost:6060/";
  await appState.loadThemeMode();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    return User.isLoggedIn;
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
            future: _checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == true) {
                return MyHomePage();
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

  final List<Widget> _pages = [
    const HomePage(),
    StatisticsPage(),
    RankingPage(),
    const ChatsPage(),
    const CalendarPage(),
  ];

  @override
  void initState() {
    print('${AppStateSingleton().userProfileImageUrlNotifier}');
    super.initState();
    print('URL do perfil do usuário: ${AppStateSingleton().userProfileImageUrlNotifier.value}');
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
              color: AppColors.white.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
           surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: theme.brightness == Brightness.light
                      ? Colors.black 
                      : theme.iconTheme.color, 
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
                            : const AssetImage('assets/images/mona.png') as ImageProvider,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _showUserPage
                                  ? AppColors.lightPurple
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _showNotifications
          ? NotificationsPage()
          : _showUserPage
              ? UserPage()
              : IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Estatísticas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Ranking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Coleções',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendário',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class User {
  static bool isLoggedIn = false; 
}
