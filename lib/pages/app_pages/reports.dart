import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late Future<List> reportedUsers;
  @override
  void initState() {
    super.initState();
    reportedUsers = _fetchReportedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Reports',
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
          child: FutureBuilder<List>(
            future: reportedUsers,
            builder: (context, snapshot) {
              return _buildReports(snapshot);
            },
          ),
        ));
  }

  Future<List> _fetchReportedUsers() async {
    // Fetches the user's data from the database.
    var uid = supabase.auth.currentUser!.id;
    print(uid);
    var list = await supabase
        .from('reports')
        .select(
            'report_reported_user_fkey (first_name), report_report_by_fkey(first_name), reason, status, report_date')
        .eq('report_by', uid);
    print(list);
    return list;
  }

  Widget _buildReports(AsyncSnapshot<List> snapshot) {
    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.data!.isEmpty) {
      return const Center(
        child: Text('No reported users'),
      );
    }
    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return _reportedUserCard(snapshot.data![index]);
        });
  }

  Widget _reportedUserCard(param0) {
    DateTime reportDate = DateTime.parse(param0['report_date']);
    final now = DateTime.now();
    final difference = now.difference(reportDate);
    final differenceInDays = difference.inDays;
    String timeAgo;
    if (differenceInDays == 0) {
      final differenceInMinutes = difference.inMinutes;
      if (differenceInMinutes < 60) {
        timeAgo = '${differenceInMinutes}m ago';
        if (differenceInMinutes < 1) {
          timeAgo = 'Just now';
        }
      } else {
        final differenceInHours = difference.inHours;
        timeAgo = '${differenceInHours}h ago';
      }
    } else {
      timeAgo = '${differenceInDays}d ago';
    }
    return Card(
        color: Colors.white10,
        child: ListTile(
          title: Text(
            param0['report_reported_user_fkey']['first_name'],
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                param0['reason'],
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Reported $timeAgo',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          trailing: Text(
            param0['status'],
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
