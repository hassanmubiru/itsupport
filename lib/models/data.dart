import 'package:itsupport/main.dart' show supabase;

class Ticket {
  late final String id;
  late final String ticketNumber;
  late final String title;
  late final String description;
  late final String status;
  late final String priority;
  late final createdAt;
  late final assignedTo;
  late final reporter;
  late final department;
  late final List<Activity> activities;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.assignedTo,
    required this.reporter,
    required this.department,
    this.activities = const [],
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      ticketNumber: json['ticket_number'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['created_at']),
      assignedTo: json['assigned_to'],
      reporter: json['reporter'],
      department: json['department'],
      activities: [],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'ticket_number':ticketNumber,
      'title':title,
      'description':description,
      'status':status,
      'priority':priority,
      'created_at':createdAt.toIso8601String(),
      'assigned_to':assignedTo,
      'reporter':reporter,
      'department':department,
      'activities':activities.map((activity) => activity.toJson()).toList(),
    };
  }
}

class Activity {
  late final String id;
  late final String ticketId;
  late final String icon;
  late final String title;
  late final DateTime createdAt;
  late final String userName;

  Activity({
    required this.id,
    required this.ticketId,
    required this.icon,
    required this.title,
    required this.createdAt,
    required this.userName,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      ticketId: json['ticket_id'],
      icon: json['icon'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'icon': icon,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'user_name': userName,
    };
  }
}

class PerformanceMetric {
  late final String id;
  late final String name;
  late final double value;
  late final String unit;
  late final String trend;
  late final double trendValue;
  late final DateTime timestamp;

  PerformanceMetric({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendValue,
    required this.timestamp,
  });

  factory PerformanceMetric.fromJson(Map<String, dynamic> json) {
    return PerformanceMetric(
      id: json['id'],
      name: json['name'],
      value: (json['value'] as num).toDouble(),
      unit: json['unit'],
      trend: json['trend'],
      trendValue: (json['trend_value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'value': value,
      'trend': trend,
      'trend_value': trendValue,
    };
  }
}

// Supabase Services

class SupabaseService {
  
  // Fetch tickets from Supabase
  // Ticket CRUD 
  static Future<List<Ticket>> fetchTickets() async {
    try {
      final response = await supabase.from('tickets').select().order('created_at', ascending: false);
      return (response as List).map((ticket) => Ticket.fromJson(ticket)).toList();
    } catch (e) {
      print('Error fetching tickets: $e');
      throw Exception('Failed to load tickets');
       
    }
  }

  static Future<Ticket> fetchTicketById(String id) async {
    try {
      final response = await supabase.from('tickets').select().eq('id', id).single();
      return Ticket.fromJson(response);
    } catch (e) {
      print('Error fetching ticket by ID: $e');
      throw Exception('Failed to load ticket');
    }
  }
  static Future<Ticket>createTicket(Map<String,dynamic> ticketData) async{
    try {
      // Generate ticket number
      final ticketNumber = 'TK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      ticketData['ticket_number'] = ticketNumber;
      ticketData['created_at'] = DateTime.now().toIso8601String();
      final response = await supabase.from('tickets').insert(ticketData).single();
      final ticket = Ticket.fromJson(response);

      // Create activity
      await createActivity(
        ticket.id,
        'add_circle',
        'Ticket Created',
        ticketData['reporter']
      );
      return ticket;
    } catch (e) {
      print('Error creating ticket: $e');
      throw Exception('Failed to create ticket');
    }
  }

  static Future<void> createActivity(
    String ticketId,
    String icon,
    String title,
    String userName,
  ) async {
    try {
      final activityData = {
        'ticket_id': ticketId,
        'icon': icon,
        'title': title,
        'created_at': DateTime.now().toIso8601String(),
        'user_name': userName,
      };
      await supabase.from('activities').insert(activityData);
    } catch (e) {
      print('Error creating activity: $e');
      throw Exception('Failed to create activity');
    }
  }

  static Future<void>updateTicketStatus(String id,String status)async{
    try {
      await supabase.from('tickets').update({'status':status}).eq('id',id);
    } catch (e) {
      print('Error updating ticket status: $e');
      throw Exception('Failed to update ticket status');
    }
  }
}

