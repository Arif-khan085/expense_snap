import 'package:expense_snap/resources/customButton/buttom_nav.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For Pie Chart

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🟢 Pie Chart Section
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🟣 Buttons Below Pie Chart
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addExpense');
                  },
                  child: const Text('Add Expense'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addIncome');
                  },
                  child: const Text('Add Income'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addLoan');
                  },
                  child: const Text('Add Loan'),
                ),
              ],
            ),
          ],
        ),
      ),

      // 🟡 Bottom Navigation Bar
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 2,
        onItemSelect: (int value) {},
      ),
    );
  }

  // 🧮 Example Pie Chart Data
  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.redAccent,
        value: 40,
        title: 'Expense',
        radius: 60,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 35,
        title: 'Income',
        radius: 60,
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: 25,
        title: 'Loan',
        radius: 60,
      ),
    ];
  }
}
