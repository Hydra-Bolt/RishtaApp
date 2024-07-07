import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  late Future<List> blockedUsers;
  @override
  void initState() {
    super.initState();
    blockedUsers = _fetchBlockedUsers();
  }

  Future<List> _fetchBlockedUsers() async {
    // Fetches the user's data from the database.
    var uid = supabase.auth.currentUser!.id;
    var list = await supabase
        .from('blocked')
        .select(
            'blocked_blocked_fkey(first_name), blocked_blocker_fkey(first_name), blocked_on')
        .eq('blocker', uid);
    print(list);
    return list;
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
              'Blocked',
              style: TextStyle(color: Colors.white),
            )),
        body: FutureBuilder<List>(
          future: blockedUsers,
          builder: (context, snapshot) {
            return _buildBlockedUsers(snapshot);
          },
        ));
  }

  Widget _buildBlockedUsers(AsyncSnapshot<List> snapshot) {
    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.data!.isEmpty) {
      return const Center(
        child: Text('No blocked users', style: TextStyle(color: Colors.white)),
      );
    }
    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return _blockedUserCard(snapshot.data![index]);
        });
  }

  Widget _blockedUserCard(param0) {
    DateTime blockDate = DateTime.parse(param0['blocked_on']);
    final now = DateTime.now();
    final difference = now.difference(blockDate);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          leading: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(Icons.person),
          ),
          title: Text(param0['blocked_blocked_fkey']['first_name'],
              style: const TextStyle(color: Colors.white)),
          subtitle: Text("Blocked $timeAgo",
              style: const TextStyle(color: Colors.white54)),
        ));
  }
}
