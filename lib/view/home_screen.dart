import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_snap/resources/customButton/buttom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../controller/auth_services/auth_services.dart';
import 'expense_screen.dart';
import 'income_screen.dart';
import 'loans_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const Center(
          child: Text('Dashboard'),
      ), // Placeholder
      const ExpenseScreen(),
      const IncomeScreen(),
      const LoanScreen(),
    ];
  }

  void _onItemSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // 🔹 Current Balance Stream
  Stream<double> getCurrentBalance() {
    final uid = _authService.currentUserUid;
    if (uid == null) return Stream.value(0);

    final incomeStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('income')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.fold<double>(0, (total, doc) => total + (doc['amount']?.toDouble() ?? 0)));

    final expenseStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.fold<double>(0, (total, doc) => total + (doc['amount']?.toDouble() ?? 0)));

    final loanStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('loans')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.fold<double>(0, (total, doc) => total + (doc['amount']?.toDouble() ?? 0)));

    return rxdart.Rx.combineLatest3(
      incomeStream,
      expenseStream,
      loanStream,
          (double income, double expense, double loans) => income - expense - loans,
    );
  }

  // 🔹 Last 3 Transactions Stream
  Stream<List<Map<String, dynamic>>> getLastTransactions() {
    final uid = _authService.currentUserUid;
    if (uid == null) return Stream.value([]);

    final incomeStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('income')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['type'] = 'Income';
      return Map<String, dynamic>.from(data);
    }).toList());

    final expenseStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['type'] = 'Expense';
      return Map<String, dynamic>.from(data);
    }).toList());

    final loanStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('loans')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['type'] = 'Loan';
      return Map<String, dynamic>.from(data);
    }).toList());

    return rxdart.Rx.combineLatest3<List<Map<String, dynamic>>, List<Map<String, dynamic>>,
        List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      incomeStream,
      expenseStream,
      loanStream,
          (income, expense, loans) {
        final all = [...income, ...expense, ...loans];
        all.sort((a, b) {
          final tsA = a['timestamp'] as Timestamp?;
          final tsB = b['timestamp'] as Timestamp?;
          return tsB?.compareTo(tsA ?? Timestamp(0, 0)) ?? 0;
        });
        return all.take(3).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => await _authService.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: selectedIndex == 0
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance
            StreamBuilder<double>(
              stream: getCurrentBalance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final balance = snapshot.data ?? 0;
                return Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Current Balance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis, // prevents overflow
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: FittedBox(
                            fit: BoxFit.scaleDown, // auto-shrinks large numbers
                            alignment: Alignment.centerRight,
                            child: Text(
                              '\$${balance.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
            ),
            const SizedBox(height: 16),

            // Quick Actions
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => selectedIndex = 1),
                    child: const Text('Add Expense'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => selectedIndex = 2),
                    child: const Text('Add Income'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => selectedIndex = 3),
                    child: const Text('Add Loan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Last 3 Transactions
            const Text(
              'Last Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: getLastTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No Transactions Yet');
                }
                final transactions = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final ts = tx['timestamp'] as Timestamp?;
                    final date = ts != null
                        ? DateFormat('dd MMM yyyy').format(ts.toDate())
                        : '-';
                    return Card(
                      child: ListTile(
                        title: Text(
                            '${tx['type']} - ${tx['source'] ?? tx['lender'] ?? tx['category'] ?? ''}'),
                        subtitle: Text('Date: $date\nStatus: ${tx['status'] ?? '-'}'),
                        trailing: Text(
                          '\$${tx['amount']}',
                          style: TextStyle(
                              color: tx['type'] == 'Expense'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      )
          : _screens[selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: selectedIndex,
        onItemSelect: _onItemSelect,
      ),
    );
  }
}
