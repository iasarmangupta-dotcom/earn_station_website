import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const EarnStationApp());
}

class EarnStationApp extends StatefulWidget {
  const EarnStationApp({super.key});

  @override
  State<EarnStationApp> createState() => _EarnStationAppState();
}

class _EarnStationAppState extends State<EarnStationApp> {
  final AppState _appState = AppState();
  bool _showAuthScreen = false;

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarnStation • Watch & Earn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF2563EB),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2563EB),
          secondary: Color(0xFFF59E0B),
          surface: Color(0xFF1E293B),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    // If logged in, show Main App Navigation
    if (_appState.isLoggedIn) {
      return MainNavigationScreen(
        appState: _appState,
        onLogout: () {
          _appState.logout();
          setState(() {
            _showAuthScreen = false;
          });
        },
      );
    }

    // If auth screen triggered
    if (_showAuthScreen) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E293B),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _showAuthScreen = false;
              });
            },
          ),
          title: const Text('Authentication', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        body: AuthScreen(
          onLoginSuccess: (name, email, phone) {
            _appState.login(name, email, phone);
            setState(() {
              _showAuthScreen = false;
            });
          },
        ),
      );
    }

    // Otherwise show Public Landing Page
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            border: Border(bottom: BorderSide(color: Color(0xFF334155))),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('EarnStation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showAuthScreen = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Login / Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: LandingScreen(
        onGetStarted: () {
          setState(() {
            _showAuthScreen = true;
          });
        },
      ),
    );
  }
}
