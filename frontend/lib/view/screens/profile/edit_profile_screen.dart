// lib/view/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushibox/provider/customer_provider.dart'; // Импорт CustomerProvider

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final customer =
        Provider.of<CustomerProvider>(context, listen: false).customer;
    _nameController.text = customer?.name ?? '';
    _emailController.text = customer?.email ?? '';
    _phoneController.text = customer?.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedCustomer = Customer(
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                );
                customerProvider.updateCustomer(updatedCustomer);
                Navigator.of(context).pop();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
