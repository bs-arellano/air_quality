import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:air_quality/api_fetching.dart';
import 'package:air_quality/login_form.dart';
import 'package:air_quality/session.dart';
import 'package:air_quality/data/user_session_data.dart';
import 'package:air_quality/position_manager.dart';

import 'views/home_view.dart';
import 'views/profile_view.dart';
import 'views/data_view.dart';

void main() {
  runApp(const AirQualityApp());
}

class AirQualityApp extends StatelessWidget {
  const AirQualityApp({
    super.key,
    this.storage = const FlutterSecureStorage(),
  });
  final FlutterSecureStorage storage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen,
            brightness: PlatformDispatcher.instance.platformBrightness),
        useMaterial3: true,
      ),
      home: MainApp(
        title: 'Air Quality',
        storage: storage,
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.title, required this.storage});
  final String title;
  final FlutterSecureStorage storage;
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //States
  bool _loggedIn = false;
  bool _appLoaded = false;
  //Objects
  late PositionManager positionManager;
  late Session session;
  //App pages
  late HomeView homeTab;
  late DataView dataTab;
  late ProfileView profileTab;
  late List<Widget> _appTabs;
  int _selectedIndex = 0;

  //Change page
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Load session from storage
  void loadSession() async {
    try {
      String username = await widget.storage.read(key: 'username') ?? '';
      String token = await widget.storage.read(key: 'session_token') ?? '';
      if (username == '' || token == '') {
        throw Exception("No session found");
      }
      session = Session(username, token);
      setState(() {
        _loggedIn = true;
      });
    } catch (error) {
      setState(() {
        _loggedIn = false;
      });
    } finally {
      setState(() {
        _appLoaded = true;
      });
    }
  }

  @override
  void initState() {
    positionManager = PositionManager();
    loadSession();
    super.initState();
  }

  Future<void> formSubmitHandle(email, password) async {
    var sessionResponse = await APIFetching.fetchSession(email, password);
    if (sessionResponse.statusCode == 200) {
      final sessionData = UserSessionData.fromJson(
          jsonDecode(sessionResponse.body) as Map<String, dynamic>);
      session = Session(sessionData.name, sessionData.token);
      widget.storage.write(key: 'username', value: sessionData.name);
      widget.storage.write(key: 'session_token', value: sessionData.token);
      setState(() {
        _loggedIn = true;
      });
    }
  }

  void closeSession() {
    session = Session('', '');
    widget.storage.delete(key: 'username');
    widget.storage.delete(key: 'session_token');
    setState(() {
      _loggedIn = false;
      _selectedIndex = 0;
    });
  }

  Scaffold startingScreen() {
    const Scaffold splashScreen = Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/app_logo_512.png"),
        ),
      ),
    );
    return splashScreen;
  }

  Scaffold appScreen() {
    Scaffold loadedApp = Scaffold(
      appBar: AppBar(title: const Center(child: Text("Air Quality"))),
      body: _appTabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up),
            label: 'Data',
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle_outlined),
            label: 'Profile',
            backgroundColor: Theme.of(context).colorScheme.background,
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onTabTapped,
      ),
    );
    return loadedApp;
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      homeTab = HomeView(
          positionManager: positionManager, token: session.access_token);
      dataTab = DataView(token: session.access_token);
      profileTab = ProfileView(session: session, closeSession: closeSession);
      _appTabs = <Widget>[homeTab, dataTab, profileTab];
    }

    return _appLoaded
        ? _loggedIn
            ? appScreen()
            : LoginForm(formSubmitHandle: formSubmitHandle)
        : startingScreen();
  }
}
