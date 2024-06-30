import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/colors.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late Future<List> acceptedMatches;
  late Future<List> pendingMatches;

  @override
  void initState() {
    super.initState();
    acceptedMatches = getAccepted();
    pendingMatches = getPending();
  }

  Future<List> getAccepted() async {
    return await supabase
        .from('matches')
        .select(
            'request_by, request_to, request_date, status, matches_request_by_fkey(name), matches_request_to_fkey(name)')
        .eq("status", "Accepted");
  }

  Future<List> getPending() async {
    return await supabase
        .from('matches')
        .select(
            'request_by, request_to, request_date, status, matches_request_by_fkey(name), matches_request_to_fkey(name)')
        .eq("status", "Waiting for response");
  }

  Widget _buildAccepted() {
    return FutureBuilder<List>(
      future: acceptedMatches,
      builder: (context, snapshot) {
        return _buildMatches(snapshot);
      },
    );
  }

  Widget _buildPending() {
    return FutureBuilder<List>(
      future: pendingMatches,
      builder: (context, snapshot) {
        return _buildMatches(snapshot);
      },
    );
  }

  Widget _buildMatches(AsyncSnapshot<List> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
          child: Text(
        'Nothing Found.',
        style: TextStyle(color: Colors.white),
      ));
    } else {
      var matches = snapshot.data!;
      return ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          var match = matches[index];
          print(match);
          return const Card(
            child: ListTile(
              title: Text('Title '),
              subtitle: Text('Subtitle '),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Connections',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: MainColors.mainThemeColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: MainColors.mainThemeColor,
            overlayColor: MaterialStatePropertyAll(Colors.white10),
            tabs: [
              Tab(text: 'Accepted'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAccepted(),
            _buildPending(),
          ],
        ),
      ),
    );
  }
}
