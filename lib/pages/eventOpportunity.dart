import 'package:flutter/material.dart';
import 'package:way2techv1/widget/event_card.dart';
import 'package:way2techv1/widget/navbar.dart';
import 'package:way2techv1/widget/opportunity_card.dart';

class Eventopprotunities extends StatefulWidget {
  final String email;
  const Eventopprotunities({required this.email});

  @override
  _EventopprotunitiesState createState() => _EventopprotunitiesState();
}

class _EventopprotunitiesState extends State<Eventopprotunities> {
  bool showEvents = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade200, Colors.blue.shade200],
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showEvents = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: showEvents ? Colors.blue.shade50 : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Events',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: showEvents ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showEvents = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !showEvents ? Colors.blue.shade50 : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Opportunities',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !showEvents ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  showEvents ? const EventsList() : const OpportunitiesList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(email: widget.email,initialIndex: 2,),
    );
  }
}

class EventsList extends StatelessWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const EventCard(
          title: 'Beyond Tech 2.0',
          date: '27/11/2024',
          time: '10AM - 5PM',
          location: 'Microsoft, Hyderabad',
          imageUrl: 'https://example.com/event-image.jpg',
        );
      },
    );
  }
}

class OpportunitiesList extends StatelessWidget {
  const OpportunitiesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const OpportunityCard(
          title: 'Software Engineer',
          company: 'Microsoft',
          location: 'Hyderabad',
          jobType: 'Full Time',
          stipend: '₹15L - 25L/year',
          imageUrl: 'https://example.com/company-logo.jpg',
        );
      },
    );
  }
}