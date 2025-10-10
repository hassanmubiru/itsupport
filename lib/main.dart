import 'package:flutter/material.dart';
import 'package:itsupport/models/provider.dart';
import 'package:itsupport/screens/dashboardscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ecawufdnvrumotvoxfch.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjYXd1ZmRudnJ1bW90dm94ZmNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAwNDIyMDQsImV4cCI6MjA3NTYxODIwNH0.K5ZOQ5bM0g4k0fdei5EutY3ze4xp-nmXq5bzRQKzo-c',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT Support',
      theme: ThemeData(
       
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: MyHomePage(),
    debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final Provider provider = Provider();
  @override
  void initState() {
    super.initState();
    provider.loadTickets();
    provider.loadMetrics();
    provider.startRealtimeUpdates();
  }
@override
void dispose(){
  provider.stopRealtimeUpdates();
  super.dispose();
}

  
  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(provider: provider),
      TicketScreen(provider: provider),
      PerformanceScreen(provider: provider),
      ProfileScreen(),
    ];
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.support_agent_outlined),
            selectedIcon: Icon(Icons.support_agent),
            label: 'Tickets',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Performance',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        

        ],
      ),
    );
  }
}