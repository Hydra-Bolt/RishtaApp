import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
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
    } catch (error) {
      // Handle the error appropriately here
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Text('SignOut'),
            onTap: () async {
              await supabase.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          userData == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text('Name: ${userData!['name']}'),
                      Text('Weight: ${userData!['weight']}'),
                      Text('Height: ${userData!['height']}'),
                      Text('Age: ${userData!['age']}'),
                      Text('Date of Birth: ${userData!['dob']}'),
                      Text('Gender: ${userData!['gender']}'),
                      Text('Country: ${userData!['country']}'),
                      Text('City: ${userData!['city']}'),
                      Text('Spouse: ${userData!['spouse']}'),
                      Text('Kids: ${userData!['kids']}'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
