
import 'package:expense_tracker/widgets/expense_list/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
class ExpensesList extends StatelessWidget{

  const ExpensesList({super.key, required this.expenses, required this.onDismiss});

  final List<Expense>expenses;

  final Function (int index) onDismiss;
  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder:
        (ctx,index)=> Dismissible(

            key: ValueKey(expenses[index]),
            background: Container(color: Theme.of(context).colorScheme.error),
            onDismissed: (direction) => onDismiss(index),
            child: ExpensesItem( expenses[index])),
    );
  }

}