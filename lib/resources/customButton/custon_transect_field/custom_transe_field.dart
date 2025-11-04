import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomTransactionField extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController categoryController;
  final TextEditingController sourceController;
  final TextEditingController dateController;

  const CustomTransactionField({
    super.key,
    required this.amountController,
    required this.categoryController,
    required this.sourceController,
    required this.dateController,
  });

  @override
  State<CustomTransactionField> createState() => _CustomTransactionFieldState();
}

class _CustomTransactionFieldState extends State<CustomTransactionField> {
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        widget.dateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration customDecoration(String hint, {Widget? prefixIcon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700]),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 💰 Amount Field
        TextFormField(
          controller: widget.amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: customDecoration('Enter Amount',
              prefixIcon: const Icon(Icons.attach_money)),
        ),
        const SizedBox(height: 10),

        // 📂 Category Field
        TextFormField(
          controller: widget.categoryController,
          readOnly: true,
          decoration: customDecoration('Select Category',
              prefixIcon: const Icon(Icons.category_outlined)),
          onTap: () async {
            final selected = await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('Select Category'),
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Food'),
                    child: const Text('Food'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Transport'),
                    child: const Text('Transport'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Shopping'),
                    child: const Text('Shopping'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Bills'),
                    child: const Text('Bills'),
                  ),
                ],
              ),
            );
            if (selected != null) {
              setState(() => widget.categoryController.text = selected);
            }
          },
        ),
        const SizedBox(height: 10),

        // 🏦 Source Field
        TextFormField(
          controller: widget.sourceController,
          readOnly: true,
          decoration: customDecoration('Select Source',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined)),
          onTap: () async {
            final selected = await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('Select Source'),
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Cash'),
                    child: const Text('Cash'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Bank'),
                    child: const Text('Bank'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, 'Credit Card'),
                    child: const Text('Credit Card'),
                  ),
                ],
              ),
            );
            if (selected != null) {
              setState(() => widget.sourceController.text = selected);
            }
          },
        ),
        const SizedBox(height: 10),

        // 📅 Date Field
        TextFormField(
          controller: widget.dateController,
          readOnly: true,
          decoration: customDecoration('Select Date',
              prefixIcon: const Icon(Icons.calendar_today_outlined)),
          onTap: () => _pickDate(context),
        ),
      ],
    );
  }
}
