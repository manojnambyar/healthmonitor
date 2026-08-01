import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_view.dart';
import 'features/logging/logging_view.dart';
import 'features/sync/google_sheets_sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GlucoseSyncApp());
}

class GlucoseSyncApp extends StatelessWidget {
  const GlucoseSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlucoseSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _syncService = GoogleSheetsSyncService();

  final List<Widget> _pages = const [
    LoggingView(),
    DashboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) async {
          setState(() => _index = value);
          if (value == 1) {
            await _syncService.syncAll(rows: _syncService.buildRows(meals: const [], insulin: const [], bloodSugar: const []));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'Log'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Dashboard'),
        ],
      ),
    );
  }
}
