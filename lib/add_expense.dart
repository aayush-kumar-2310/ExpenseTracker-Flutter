// ignore_for_file: curly_braces_in_flow_control_structures, prefer_final_fields

import 'package:flutter/material.dart';
import 'models/expense_info.dart';
import 'models/pie_data.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  int id = 3, expNo = 0;
  String a = "", b = "";
  String _date = "Select date";
  String? _selectedVal = "Shopping";
  final List<String> _options = [
    "Shopping",
    "Food",
    "Bill",
    "Entertainment",
    "Others",
  ];

  setImageId() {
    if (_selectedVal == "Shopping") {
      id = 4;
      amount['Shopping'] = int.parse(b) + amount['Shopping']!;
    } else if (_selectedVal == "Others") {
      id = 3;
      amount['Others'] = int.parse(b) + amount['Others']!;
    } else if (_selectedVal == "Bill") {
      id = 0;
      amount['Bill'] = int.parse(b) + amount['Bill']!;
    } else if (_selectedVal == "Food") {
      amount['Food'] = int.parse(b) + amount['Food']!;
      id = 1;
    } else if (_selectedVal == "Entertainment") {
      id = 2;
      amount['Entertainment'] = int.parse(b) + amount['Entertainment']!;
    }
  }

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
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setImageId();

              final generatedExpense = Expense(
                  id: id,
                  expNo: expNo++,
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
