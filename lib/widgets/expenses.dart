import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/model/expense.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expense_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpese = [
    Expense(
        title: 'flutter course',
        amount: 300,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'big mac',
        amount: 170,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'cinma',
        amount: 200,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'travel to cairo',
        amount: 100,
        date: DateTime.now(),
        category: Category.travel),
  ];

  void _openAddExpenseOverly() {
    showModalBottomSheet(
      useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddNewExpnse: _addNewExpense));
  }

  void _addNewExpense(Expense expense) {
    setState(() {
      _registerExpese.add(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Expense added'),
          backgroundColor: Colors.green),
    );
  }

  void _removeNewExpense(Expense expense) {
    final expenceIndex = _registerExpese.indexOf(expense);
    setState(() {
      _registerExpese.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registerExpese.insert(expenceIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('There Is No Expense , Start to add one'),
    );
    if (_registerExpese.isNotEmpty) {
      mainContent = ExpenseList(
        expense: _registerExpese,
        onRemoveExpense: _removeNewExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverly,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registerExpese),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Row(children: [
              Expanded(
                child: Chart(expenses: _registerExpese),
              ),
              Expanded(
                child: mainContent,
              )
            ]),
    );
  }
}
