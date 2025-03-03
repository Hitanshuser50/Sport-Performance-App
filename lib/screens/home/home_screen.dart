import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsmate/providers/auth_provider.dart';
import 'package:sportsmate/screens/games/games_screen.dart';
import 'package:sportsmate/screens/players/players_screen.dart';
import 'package:sportsmate/screens/performance/performance_screen.dart';
import 'package:sportsmate/screens/profile/profile_screen.dart';
import 'package:sportsmate/utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const GamesScreen(),
      const PlayersScreen(),
      const PerformanceScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_soccer),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Players',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Performance',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
