import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single();

      setState(() {
        userData = response;
      });
      if (!mounted) return;
      if (userData!['lid'] == null) {
        Navigator.of(context).pushReplacementNamed('/lifestyle');
      } else if (userData!['pid'] == null) {
        Navigator.of(context).pushReplacementNamed('/preference');
      }
    } catch (error) {
      // Handle the error appropriately here
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/userform');
        print('Error fetching user data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: const Text('SignOut'),
            onTap: () async {
              await supabase.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          userData == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Text('Name: ${userData!['name']}'),
                        Text('Weight: ${userData!['weight']}'),
                        Text('Height: ${userData!['height']}'),
                        Text('Age: ${userData!['age']}'),
                        Text('Date of Birth: ${userData!['dob']}'),
                        Text('Gender: ${userData!['gender']}'),
                        // Text('Country: ${userData!['country']}'),
                        Text('City: ${userData!['city']}'),
                        Text('Spouse: ${userData!['spouse']}'),
                        Text('Kids: ${userData!['kids']}'),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
