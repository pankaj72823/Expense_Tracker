// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/widgets/expenses.dart';


final formatter = DateFormat.yMd();
class NewExpense extends StatefulWidget{
  const NewExpense({ super.key, required this.onAddExpense});

  final void  Function (Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
   return _NewExpense();
  }

}

class _NewExpense extends State<NewExpense>{

  late final Expense data;

  // void updateItem(){
  //   Expenses(expenseData: data,);
  // }
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _presentDatePicker() async{
     DateTime initial = DateTime.now();
    DateTime firstDate = DateTime(initial.year - 1, initial.month, initial.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: firstDate,
        lastDate: initial
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {

    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount ==null || enteredAmount<=0 ;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title:  const Text("Invalid True"),
        content: const Text("please make sure a valid title ,amount and date was entered") ,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Okay')),
        ],
      ),
      );
      return ;

      //show error message
    }
    else{
      widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        category: _selectedCategory,
        date: _selectedDate!,
      ),
      );
      Navigator.pop(context);
    }

  }
  Category _selectedCategory = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.fromLTRB(16,48,16,keyboard + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),

          const SizedBox(height: 30,),

          Row(
            children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration:  const InputDecoration(
                prefixText: 'Rs ',
                label: Text('Amount'),
              ),
            ),
          ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        _selectedDate == null ?
                        "No date selected ": formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed: () => _presentDatePicker(),
                        icon: const Icon(Icons.calendar_month)),
                            ],
                          ),
              ),
          ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                  items: Category.values.map(
                      (category)=> DropdownMenuItem(
                        value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                      ),
              ).toList(), onChanged:(value) {
                if(value==null){
                  return;
                }
                setState(() {
                  _selectedCategory = value;
                });
              }),
              ElevatedButton(
                  onPressed: () => _submitExpenseData(),
                  child: const Text('Save expense')),

              ElevatedButton(onPressed: () => Navigator.pop(context),
                  child: const Text('Close')),
            ],

          )
        ],
      )
        ),
        ),
    );
  }

}

