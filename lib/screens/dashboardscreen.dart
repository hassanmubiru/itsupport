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
          if(provider.isloading && provider.metrics.isEmpty){
            return const Center(child:CircularProgressIndicator());
          }

          if(provider.error != null){
            return Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 65),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (){
                      provider.loadTickets();
                      provider.loadMetrics();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              )
            );
          }

          final openTickets = provider.tickets.where((t) => t.status == 'Open').length;
          final resolvedTickets = provider.tickets.where((t) => t.status == 'Resolved').length;
          final pendingTickets = provider.tickets.where((t) => t.status == 'Pending').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0) ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live Status
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Live :Real-time Updates Active', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                      ],
                    )
                  ),
                ),
                const SizedBox(height: 16),
                // cardsinfo
                Row(
                  children:[
                    Expanded(
                      child: CardInfo(
                        title: 'Open Tickets',
                        value: '$openTickets',
                        icon: Icons.confirmation_number,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CardInfo(
                        title: 'Resolved Tickets',
                        value: '$resolvedTickets',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CardInfo(
                        title: 'Pending Tickets',
                        value: '$pendingTickets',
                        icon: Icons.pending,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CardInfo(
                        title: 'Total',
                        value: '${provider.tickets.length}',
                        icon: Icons.list,
                        color: Colors.purple,
                      ),
                    ),
                  ]
                ),
                const SizedBox(height: 24),
                // Performance
                const Text(
                  'System Performance',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...provider.metrics.map((metric){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PerformanceCard(
                          title: '${metric.name} Usage',
                          value: metric.value.toInt(),
                          color: getMetricColor(metric.name),
                        )
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                // Recent Tickets
                const Text(
                  'Recent Tickets',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...provider.tickets.take(5).map((ticket){
                  return RecentTicketItem(
                    title:ticket.title,
                    status:ticket.status,
                    priority:ticket.priority,
                    createdAt:ticket.createdAt,
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(context) => TicketDetailScreen(ticket:ticket,provider:provider),
                        )
                      );
                    }
                  );
                })
              ],
            ),
          );
        }
      )
    )
    );
  }
}

Color getMetricColor(String name) {
  switch (name.toLowerCase()) {
    case 'cpu':
      return Colors.blue;
    case 'memory':
      return Colors.orange;
    case 'disk':
      return Colors.green;
    default:
      return Colors.purple;
  }
}
String formatTime(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon,color:color,size:32),
                const SizedBox(height: 8),
                Text(title, style: TextStyle(fontSize:24, fontWeight:FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const PerformanceCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('$value%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: value / 100),
              duration: const Duration(milliseconds: 800),
              builder: (context, val, _) {
                return LinearProgressIndicator(
                  value: val,
                  color: color,
                  backgroundColor: Colors.grey[200],
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                );
              },
            )
          ]
        ),
      ),
    );
  }
}

class RecentTicketItem extends StatelessWidget {
  final String title;
  final String status;
  final String priority;
  final DateTime createdAt;
  final VoidCallback onTap;

  const RecentTicketItem({
    super.key,
    required this.title,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.onTap,
  });

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 9.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Priority: $priority • Created: ${formatTime(createdAt)}'),
        leading: CircleAvatar(
          backgroundColor: getPriorityColor(priority).withOpacity(0.1),
          child: Icon(
            Icons.priority_high,
            color: getPriorityColor(priority),
          ),
          
        ),
        onTap: onTap,
        subtitle: Text('$priority • ${formatTime(createdAt)}'),
        trailing: Chip(
          label:Text(
            priority
            ,style:const TextStyle(fontSize:12),
        ),
        backgroundColor: getPriorityColor(  priority).withOpacity(0.1),
        side:BorderSide.none,
        ),
      ),
    );
  }
  
}