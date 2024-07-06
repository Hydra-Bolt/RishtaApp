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
    return await supabase.from('blocked').select().eq('blocker', uid);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
          title: const Text('Blocked Users'),
        ),
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
        child: Text('No blocked users'),
      );
    }
    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return _blockedUserCard(snapshot.data![index]);
        });
  }

  Widget _blockedUserCard(param0) {
    return Card(
        color: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: const Icon(Icons.person),
            ),
            title: Text(param0['blocked'])));
  }
}
