import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget{
  const Expenses( {super.key});


  @override
  State<Expenses> createState() {
    return _Expenses();
  }

}

class _Expenses extends State<Expenses>{

   final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.93339,
        date: DateTime.now(),
        category: Category.work
    ),
    Expense(
        title: 'Cinema',
        amount: 15.68,
        date: DateTime.now(),
        category: Category.leisure
    ),
  ];
  void _openAddExpenseOverlay(){
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,context: context, builder: (ctx) {
      return NewExpense(onAddExpense: _addExpense);
    });
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(int index){
    final expense = _registeredExpenses.elementAt(index);
    setState(() {
      _registeredExpenses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: const Text('Expense deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: (){
              setState(() {
                _registeredExpenses.insert(index,expense);
              });
            },
          ),
        )
    );
  }
  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expense Found'),
    );
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
          expenses: _registeredExpenses,
          onDismiss: _removeExpense);
    }
   return Scaffold(
     appBar: AppBar(
       title: const Text('Flutter Expense Tracker App', style: TextStyle(
         color: Colors.white,
       ),),
       actions: [

         IconButton(icon:const Icon(Icons.add), onPressed: () {
          return _openAddExpenseOverlay();
         },)
       ],
     ),
     body: width < 600 ? Column(
       children: [
         Chart(expenses: _registeredExpenses),
         Expanded(child: mainContent),
       ],
     ):
     Row(
       children: [
         Expanded(child: Chart(expenses: _registeredExpenses)),
         Expanded(child: mainContent),
       ],
     ),
   );

  }

}