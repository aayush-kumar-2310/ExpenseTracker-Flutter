// import 'package:expense_tracker/models/expense_info.dart';

import 'package:flutter/material.dart';
import 'add_expense.dart';
import 'models/expense_info.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Tracker",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewExpense()));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result)));
              setState(() {});
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: listOfExpense.length,
                itemBuilder: (context, index) {
                  // final expense = listOfExpense[index];
                  return Dismissible(
                      background: Container(
                        color: Colors.red,
                      ),
                      secondaryBackground: Container(color: Colors.red),
                      onDismissed: (direction) {
                        listOfExpense.removeAt(index);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Removed!"),
                        ));
                      },
                      key: UniqueKey(),
                      child: ListTile(
                        tileColor: Colors.green,
                        leading: const Icon(Icons.restaurant),
                        trailing: Text(listOfExpense[index].amount),
                        subtitle: Text(listOfExpense[index].category),
                        title: Text(listOfExpense[index].title),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
