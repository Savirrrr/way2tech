import 'package:flutter/material.dart';

class TabSwitchingPage extends StatefulWidget {
  @override
  _TabSwitchingPageState createState() => _TabSwitchingPageState();
}

class _TabSwitchingPageState extends State<TabSwitchingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events and Opportunities'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Events'),
            Tab(text: 'Opportunities'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(),
          _buildOpportunitiesList(),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      itemCount: 5, // Replace with dynamic count of events
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey,
              ),
              title: Text('Beyond Tech 2.0'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('27/11/2024 | 10AM - 5PM'),
                  Text('Microsoft, Hyderabad'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpportunitiesList() {
    return ListView.builder(
      itemCount: 5, // Replace with dynamic count of opportunities
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey,
              ),
              title: Text('Web Dev Intern'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Learn-x | Internship'),
                  Text('2.5k - 5k/month'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: Text('Apply'),
              ),
            ),
          ),
        );
      },
    );
  }
}
