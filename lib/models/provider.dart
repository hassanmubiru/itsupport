import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itsupport/models/data.dart';

class Provider extends ChangeNotifier {
  // Define your provider variables and methods here
  List<Ticket> tickets = [];
  List<PerformanceMetric> metrics = [];
  bool isloading = false;
  String? error;
  StreamSubscription? ticketSubscription;
  StreamSubscription? metricSubscription;

  List<Ticket> get ticket => tickets;
  List<PerformanceMetric> get metric => metrics;
  // bool get isloading => isloading;
  // String? get error => error;

  Future<void>loadTickets()async{
    isloading = true;
    error = null;
    notifyListeners();
    try{
      tickets = await SupabaseService.fetchTickets();
    } catch (e) {
      error = 'Failed to load tickets:$e';
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  Future<void>createTicket(Map<String,dynamic>ticketData)async{
    isloading = true;
    error = null;
    notifyListeners();
    try{
      await SupabaseService.createTicket(ticketData);
      await loadTickets();
    } catch (e) {
      error = 'Failed to create ticket:$e';
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  Future<void>loadMetrics()async{
    isloading = true;
    error = null;
    notifyListeners();
    try{
      metrics = await SupabaseService.fetchPerformanceMetrics();
    } catch (e) {
      error = 'Failed to load performance metrics:$e';
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  void startRealtimeUpdates(){
    ticketSubscription = SupabaseService.subscribeToTickets().listen((tickets){
      this.tickets = tickets;
      notifyListeners();
    });

//Subscribe to metrics real-time updates
    metricSubscription = SupabaseService.subscribeToMetrics().listen((metrics){
      this.metrics = metrics;
      notifyListeners();
    });
  }
}