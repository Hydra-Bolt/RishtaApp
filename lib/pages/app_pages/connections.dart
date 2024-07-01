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
    setMatches();
  }

  Future<List> getAccepted() async {
    return await supabase
        .from('matches')
        .select(
            'request_by, request_to, request_date, status, matches_request_by_fkey(name), matches_request_to_fkey(name)')
        .eq("request_by", supabase.auth.currentUser!.id)
        .eq("status", "Accepted");
  }

  Future<List> getPending() async {
    return await supabase
        .from('matches')
        .select(
            'request_by, request_to, request_date, status, matches_request_by_fkey(name), matches_request_to_fkey(name)')
        .eq("request_by", supabase.auth.currentUser!.id)
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
        ),
      );
    } else {
      var matches = snapshot.data!;
      return ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          var match = matches[index];
          return Card(
            color: Colors.white10, // Add your color here
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              leading: CircleAvatar(
                backgroundColor: Colors.white, // Add your color here
                child: Text(
                  match['matches_request_to_fkey']['name']
                      [0], // Display the first letter of the name
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              title: Text(
                match['matches_request_to_fkey']['name'],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                match['request_date'] == null
                    ? 'Sent on Unknown Date'
                    : 'Sent on ${DateTime.parse(match['request_date']).toString().split(' ').first}',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  match['status'] != 'Accepted'
                      ? GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.grey[700],
                              titleTextStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              contentTextStyle: const TextStyle(fontSize: 16),
                              title: const Text('Cancel request?'),
                              content: const Text(
                                  'Are you sure you want to cancel the request?'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(), // Dismisses the dialog
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: MainColors.mainThemeColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => cancelMatchRequest(
                                      match['request_by'], match['request_to']),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                        color: MainColors.mainThemeColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.cancel_schedule_send_sharp,
                            color: Colors.red,
                          ),
                        )
                      : Icon(Icons.check_circle, color: Colors.green)
                ],
              ),
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

  cancelMatchRequest(requestBy, requestTo) async {
    print(requestBy);
    print(requestTo);
    final res = await supabase
        .from('matches')
        .delete()
        .eq('request_by', requestBy)
        .eq("request_to", requestTo);
    print(res);
    setMatches();
    Navigator.of(context).pop();
  }

  void setMatches() {
    setState(() {
      acceptedMatches = getAccepted();
      pendingMatches = getPending();
    });
  }
}
