import 'package:flutter/material.dart';
import 'package:way2techv1/widget/navbar.dart';

class TabSwitchingPage extends StatefulWidget {
  final String email;
  const TabSwitchingPage({super.key, required this.email});
  @override
  // ignore: library_private_types_in_public_api
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
        automaticallyImplyLeading: false, // Removes back arrow
        titleSpacing: 0, // Removes extra padding at the title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0), // Height of the TabBar
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.grey[800], // Darker background for selected tab
              borderRadius:
                  BorderRadius.circular(4), // Optional: rounded corners
            ),
            labelColor: Colors.white, // Text color for selected tab
            unselectedLabelColor:
                Colors.white70, // Text color for unselected tabs
            tabs: const [
              Tab(text: 'Events'),
              Tab(text: 'Opportunities'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(),
          _buildOpportunitiesList(),
        ],
      ),
      bottomNavigationBar: Navbar(
        email: widget.email,
        initialIndex: 2,
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
              title: const Text('Beyond Tech 2.0'),
              subtitle: const Column(
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
              title: const Text('Web Dev Intern'),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Learn-x | Internship'),
                  Text('2.5k - 5k/month'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Apply'),
              ),
            ),
          ),
        );
      },
    );
  }
}
