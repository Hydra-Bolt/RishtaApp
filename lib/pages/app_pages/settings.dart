import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/colors.dart';
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
    var response = await supabase
        .from('Users')
        .select("first_name")
        .eq('uid', uid)
        .single();
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
                      userData?['first_name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@" +
                          supabase.auth.currentUser!.userMetadata!['username'],
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
      onTap: onTap,
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            title == "Profile Views"
                ? Text(
                    '73',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                : Container(),
            SizedBox(width: dim.width(2)),
            title != "Profile Views" && title != "Logout"
                ? Icon(Icons.chevron_right, color: Colors.white)
                : Container(),
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
                    onTap: () {
                      Navigator.pushNamed(context, '/blocked');
                    },
                  ),
                  SizedBox(height: dim.height(1)),
                  _buildCard(
                    context,
                    'Reports',
                    Icons.report,
                    onTap: () {
                      Navigator.pushNamed(context, '/reports');
                    },
                  ),
                  SizedBox(height: dim.height(1)),
                  _buildCard(
                    context,
                    'Profile Views',
                    Icons.visibility,
                  ),
                  SizedBox(height: dim.height(1)),
                  _buildCard(
                    context,
                    'Logout',
                    Icons.logout,
                    onTap: () {
                      logoutConfimationDialogue(context);
                    },
                  ),
                  SizedBox(height: dim.height(1)),
                ],
              ),
            ),
    );
  }

  Future<dynamic> logoutConfimationDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: EdgeInsets.all(20),
        backgroundColor: Colors.grey[700],
        titleTextStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        contentTextStyle: const TextStyle(fontSize: 16),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: MainColors.mainThemeColor)),
          ),
          TextButton(
            onPressed: () {
              // Sign out of Supabase
              supabase.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: const Text('Logout',
                style: TextStyle(color: MainColors.mainThemeColor)),
          ),
        ],
      ),
    );
  }
}
