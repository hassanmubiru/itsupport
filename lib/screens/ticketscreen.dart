import 'package:flutter/material.dart';

class Ticketscreen extends StatefulWidget {
  const Ticketscreen({super.key});

  @override
  State<Ticketscreen> createState() => _TicketscreenState();
}

class _TicketscreenState extends State<Ticketscreen> {
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Tickets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        searchController.clear();
                      });
                    },
                  ) : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  label: 'All',
                  isSelected: selectedFilter == 'All',
                  onTap:()=>setState(() => selectedFilter = 'All'),
                ),  
               
                FilterChip(
                  label: 'Open',
                  isSelected: selectedFilter == 'Open',
                  onTap:()=>setState(() => selectedFilter = 'Open'),
                ),
                FilterChip(
                  label: 'In Progress',
                  isSelected: selectedFilter == 'In Progress',
                  onTap:()=>setState(() => selectedFilter = 'In Progress'),
                ),
                FilterChip(
                  label: 'Closed',
                  isSelected: selectedFilter == 'Closed',
                  onTap:()=>setState(() => selectedFilter = 'Closed'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

        // Ticket List
        Expanded(
          child: ListenableBuilder(
            listenable: widget.provider,
            builder:(context, _) {
              if (widget.provider.isloading && widget.provider.tickets.isEmpty) {
                return const Center(child:CircularProgressIndicator());
                
              }
              var filteredTickets = widget.provider.tickets;
              if(selectedFilter != 'All') {
                filteredTickets = filteredTickets.where((ticket) => ticket.status == selectedFilter).toList();
              }
              if(searchQuery.isNotEmpty) {
                filteredTickets = filteredTickets.where((ticket) => ticket.title.toLowerCase().contains(searchQuery) || ticket.description.toLowerCase().contains(searchQuery) || ticket.ticketNumber.toString().contains(searchQuery)).toList();
              }

              if(filteredTickets.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text('No tickets found', style: TextStyle(color: Colors.grey)),
                    ],
                    ),
                );
              }
              return ListView.builder(
                itemCount: filteredTickets.length,
                itemBuilder: (context, index) {
                  final ticket = filteredTickets[index];
                  return ListTile(
                    title: Text(ticket.title),
                    subtitle: Text(ticket.description),
                    trailing: Text(ticket.status),
                  );
                },
              );
            },
          ),
        )
        ],
      ),
    );
  }
}