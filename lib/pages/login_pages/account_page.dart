import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _spouseController = TextEditingController();
  final _kidsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _spouseController.dispose();
    _kidsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await supabase.from('users').insert({
          'uid': supabase.auth.currentUser!.id,
          'name': _nameController.text,
          'weight': int.tryParse(_weightController.text),
          'height': int.tryParse(_heightController.text) ?? 0,
          'age': int.tryParse(_ageController.text) ?? 0,
          'dob': _dobController.text,
          'gender': _genderController.text,
          'country': _countryController.text,
          'city': _cityController.text,
          'spouse': int.tryParse(_spouseController.text) ?? 0,
          'kids': int.tryParse(_kidsController.text) ?? 0,
        });
        if (response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User data saved successfully!')));
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response.error!.message}')));
        }
      } on AuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      } on PostgrestException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                    labelText: 'Date of Birth (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: _spouseController,
                decoration: const InputDecoration(labelText: 'Spouse'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _kidsController,
                decoration: const InputDecoration(labelText: 'Kids'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
