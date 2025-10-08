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
    required this.activities,
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
      activities: (json['activities'] as List)
          .map((activity) => Activity(activity, id: '', ticketId: '', icon: '', title: '', createdAt: null, userName: ''))
          .toList(),
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

  Activity(activity, {
    required this.id,
    required this.ticketId,
    required this.icon,
    required this.title,
    required this.createdAt,
    required this.userName,
  });
}

factory Activity.fromJson(Map<String,dynamic>json){
  return Activity();
}