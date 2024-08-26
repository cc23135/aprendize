import 'package:flutter/material.dart';
import 'home_page.dart';
import 'statistics_page.dart';
import 'ranking_page.dart';
import 'chats_page.dart';
import 'calendar_page.dart';
import 'notifications_page.dart';
import 'user_page.dart';
import 'login-page.dart';
import 'colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBlackForFooter,
          elevation: 1,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.black,
          selectedItemColor: AppColors.lightPurple,
          unselectedItemColor: AppColors.white,
        ),
      ),
      home: User.isLoggedIn ? MyHomePage() : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _showNotifications = false;
  bool _showUserPage = false;

  final List<Widget> _pages = [
    HomePage(),
    StatisticsPage(),
    RankingPage(),
    ChatsPage(),
    CalendarPage(),
  ];

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.white.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: _showNotifications ? AppColors.lightPurple : AppColors.white,
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
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage('assets/images/mona.png'),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _showUserPage ? AppColors.lightPurple : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                )
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
              color: AppColors.white.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.black,
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
          selectedItemColor: AppColors.lightPurple,
          unselectedItemColor: AppColors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class User {
  static bool isLoggedIn = false; // Simula a autenticação do usuário
}
