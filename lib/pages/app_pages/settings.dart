import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/dimensions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  Map<String, dynamic>? userData;
  bool isLoading = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    isLoading = true;
    // Fetches the user's data from the database.
    var uid = supabase.auth.currentUser!.id;
    print("CURRENT UID: $uid");
    var response =
        await supabase.from('users').select("name").eq('uid', uid).single();
    print(response);
    setState(() {
      userData = response;
      isLoading = false;
    });
  }

  Widget _profileCard(BuildContext context) {
    var dim = Dimensions(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            // margin: EdgeInsets.symmetric(horizontal: dim.width(30), vertical: 3),
            padding: EdgeInsets.all(dim.height(3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: dim.height(5),
                  child: const Icon(Icons.person),
                ),
                SizedBox(height: dim.height(2)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userData?['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      supabase.auth.currentUser!.email!,
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      {Function()? onTap}) {
    final dim = Dimensions(context);
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        // margin: EdgeInsets.symmetric(horizontal: dim.width(3), vertical: 3),
        padding: EdgeInsets.all(dim.height(3)),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var dim = Dimensions(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: dim.height(1)),
                  _profileCard(context),
                  SizedBox(height: dim.height(1)),
                  _buildCard(
                    context,
                    'Blocked Users',
                    Icons.block,
                  ),
                  SizedBox(height: dim.height(1)),
                  _buildCard(context, 'Reports', Icons.report),
                  SizedBox(height: dim.height(1)),
                  _buildCard(context, 'Profile Views', Icons.visibility),
                  SizedBox(height: dim.height(1)),
                  _buildCard(context, 'Logout', Icons.logout),
                  SizedBox(height: dim.height(1)),
                ],
              ),
            ),
    );
  }
}
