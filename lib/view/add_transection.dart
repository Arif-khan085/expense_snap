import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_snap/resources/customButton/buttom_nav.dart';
import 'package:expense_snap/view/expense_screen.dart';
import 'package:expense_snap/view/income_screen.dart';
import 'package:expense_snap/view/loans_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final selectedIndex = 0.obs;
  String _selectedType = 'Expense'; // Default transaction type

  // 🔹 Firestore instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  // 🔹 Save transaction to Firestore
  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Determine collection name based on selected type
      String collectionName = _selectedType.toLowerCase() + 's';
      // Example: Expense → expenses

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection(collectionName)
          .add({
        'title': _titleController.text,
        'amount': double.parse(_amountController.text),
        'category': _categoryController.text,
        'date': _dateController.text,
        'type': _selectedType,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_selectedType added successfully!')),
      );

      // Clear input fields
      _titleController.clear();
      _amountController.clear();
      _categoryController.clear();
      _dateController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding $_selectedType: $e')),
      );
    }
  }

  // 🔹 Date picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = picked.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- Transaction Type Buttons ---
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex.value == 0
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      onPressed: () {
                        selectedIndex.value = 0;
                        setState(() => _selectedType = 'Expense');
                        Get.to(() => const ExpenseScreen());
                      },
                      child: const Text('Expense'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex.value == 1
                            ? Colors.green
                            : Colors.grey[300],
                      ),
                      onPressed: () {
                        selectedIndex.value = 1;
                        setState(() => _selectedType = 'Income');
                        Get.to(() => const IncomeScreen());
                      },
                      child: const Text('Income'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex.value == 2
                            ? Colors.indigo
                            : Colors.grey[300],
                      ),
                      onPressed: () {
                        selectedIndex.value = 2;
                        setState(() => _selectedType = 'Loan');
                        Get.to(() => const LoanScreen());
                      },
                      child: const Text('Loan'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Input Fields ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title / Source',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter a title/source' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Enter an amount' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter a category' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value!.isEmpty ? 'Select a date' : null,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Transaction',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Show saved transactions from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(_uid)
                    .collection(_selectedType.toLowerCase() + 's')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No transactions found.');
                  }

                  final transactions = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final data = tx.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          title: Text('${data['title']} - ${data['type']}'),
                          subtitle: Text(
                            '${data['category']} | ${data['date']} | Rs.${data['amount']}',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 1,
        onItemSelect: (int value) {},
      ),
    );
  }
}
