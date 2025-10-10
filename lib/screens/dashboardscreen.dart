import 'package:flutter/material.dart';
import 'package:itsupport/models/provider.dart';

class DashboardScreen extends StatelessWidget {
  final Provider provider;
  const DashboardScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions:[
          IconButton(
             icon: const Icon(Icons.refresh),
             onPressed: (){
              provider.loadTickets();
              provider.loadMetrics();
            },
          ),
          IconButton(
             icon: const Icon(Icons.notifications_outlined),
             onPressed: (){

            },
          ),
        ],
      ),
     body: RefreshIndicator(
      onRefresh:()async{
        await provider.loadTickets();
        await provider.loadMetrics();
      },
      child:ListenableBuilder(
        listenable:provider,
        builder:(context,_){
          if(provider.isLoading && provider.metrics==null){
            return const Center(child:CircularProgressIndicator());
          }
        }
      )
    )
    );
  }
}

// Define CardInfo widget outside of DashboardScreen
class CardInfo extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const CardInfo({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

