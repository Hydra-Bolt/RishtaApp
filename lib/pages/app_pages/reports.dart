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
        appBar: AppBar(title: const Text('Reports')),
        body: FutureBuilder<List>(
          future: reportedUsers,
          builder: (context, snapshot) {
            return _buildReports(snapshot);
          },
        ));
  }

  Future<List> _fetchReportedUsers() async {
    // Fetches the user's data from the database.
    var uid = supabase.auth.currentUser!.id;
    return await supabase.from('reports').select().eq('report_by', uid);
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
    return Card(
        color: Colors.white10,
        child: ListTile(
          title: Text(param0['report_by']),
          subtitle: Text(param0['report_to']),
        ));
  }
}
