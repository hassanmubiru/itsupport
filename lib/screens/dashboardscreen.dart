import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions:[
          IconButton(
             icon: const Icon(Icons.notifications_outlined),
             onPressed: (){},
            
            ),
        ],
      ),
     body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // info card
          Row(
            children: [
              Expanded(
                child: CardInfo(
                  title: 'Open Tickets',
                  value:'12',
                  icon:Icons.confirmation_number,
                  color:Colors.orange,

                ),
              ),
              const SizedBox(width: 16,),
                Expanded(
                child: CardInfo(
                  title: 'Open Tickets',
                  value:'12',
                  icon:Icons.confirmation_number,
                  color:Colors.orange,
                ),
                ),
              
            ],
          )
        ],
      ),
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