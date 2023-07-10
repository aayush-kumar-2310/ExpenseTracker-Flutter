// import 'package:expense_tracker/models/expense_info.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/pie_data.dart';
import 'package:flutter/material.dart';
import '../add_expense.dart';
import '../models/expense_info.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final arrayImage = [
    const AssetImage('assets/images/bill.png'),
    const AssetImage('assets/images/burger.png'),
    const AssetImage('assets/images/content.png'),
    const AssetImage('assets/images/more.png'),
    const AssetImage('assets/images/online-shopping.png'),
  ];

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
              padding: const EdgeInsets.all(30),
              color: Colors.teal,
              child: PieChart(
                chartRadius: MediaQuery.of(context).size.width / 2,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesOutside: true,
                ),
                initialAngleInDegree: 0,
                dataMap: amount,
                animationDuration: const Duration(milliseconds: 1000),
                baseChartColor: Colors.green,
              ),
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
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Colors.lightBlue.shade200,
                          leading:
                              Image(image: arrayImage[listOfExpense[index].id]),
                          trailing: Text(listOfExpense[index].amount),
                          subtitle: Text(listOfExpense[index].category),
                          title: Text(listOfExpense[index].title),
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
