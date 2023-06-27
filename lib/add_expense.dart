import 'package:flutter/material.dart';
import 'models/expense_info.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String a = "", b = "";
  String _date = "Select date";
  String? _selectedVal = "Shopping";
  final List<String> _options = [
    "Shopping",
    "Food",
    "Bill",
    "Entertainment",
  ];

  submitDetails() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.teal,
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                titleField(),
                const SizedBox(
                  height: 20,
                ),
                amountField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      value: _selectedVal,
                      items: _options
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedVal = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? datePicked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2024));

                        if (datePicked != null) {
                          setState(() {
                            _date =
                                "${datePicked.day} / ${datePicked.month} / ${datePicked.year}";
                          });
                        }
                      },
                      child: Text(_date),
                    ),
                  ],
                ),
                Text(a),
                Text(b),
                Text(_date),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final generatedExpense = Expense(
                  title: a,
                  amount: b,
                  dateTime: _date,
                  category: _selectedVal.toString());
              listOfExpense.add(generatedExpense);
              Navigator.pop(context, 'Added!');
              //Navigator.pop(context);
            },
            child: const Text("Add entry"),
          ),
        ],
      ),
    );
  }

  Widget titleField() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: _titleController,
      onChanged: (value) {
        setState(() {
          a = _titleController.text;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        label: const Text("Expense title"),
        hintText: "Expense title",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget amountField() {
    return TextField(
      controller: _amountController,
      onChanged: (value) {
        setState(() {
          b = _amountController.text;
        });
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter amount",
        filled: true,
        fillColor: Colors.white,
        label: const Text("Amount"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
