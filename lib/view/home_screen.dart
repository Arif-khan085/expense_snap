import 'package:expense_snap/resources/customButton/buttom_nav.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/auth_services/auth_services.dart';
import '../controller/auth_services/firestore_services/firestore_services.dart';

import 'expense_screen.dart';
import 'income_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int selectedIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();

  // Screens for bottom navigation
  final List<Widget> _screens = [
    const Center(child: Text('Add Balance')), // Placeholder for Balance Tab
    ExpenseScreen(),
    IncomeScreen(),
  ];


  void _onItemSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('All Transactions'),
      actions: [
        IconButton(onPressed: ()async{
          await _authService.logout();
        }, icon: Icon(Icons.logout)),
      ],
      ),
      body: selectedIndex == 0
          ? StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('No Transactions Yet'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var doc = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('${doc['category']} (${doc['source']})'),
                  subtitle: Text('Date: ${doc['date']}'),
                  trailing: Text(
                    '\$${doc['amount']}',
                    style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      )
          : _screens[selectedIndex], // Show Expense or Income screen

      bottomNavigationBar: CustomNavigationBar(
        selectIndex: selectedIndex,
        onItemSelect: _onItemSelect,
      ),
    );
  }
}
