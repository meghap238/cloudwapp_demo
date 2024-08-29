
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  List<DataModel> dataList = [];
  List<DataModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = dataList;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  readOnly: true,
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        dataList.add(
                          DataModel(
                            title: _titleController.text,
                            date: _dateController.text,
                            time: _timeController.text,
                            description: _descriptionController.text,
                          ),
                        );
                        filteredList = List.from(dataList);
                      });

                      _titleController.clear();
                      _dateController.clear();
                      _timeController.clear();
                      _descriptionController.clear();

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fromDateController,
                decoration: InputDecoration(labelText: 'From Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _fromDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: _toDateController,
                decoration: InputDecoration(labelText: 'To Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _toDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                readOnly: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _applyFilter();
                Navigator.pop(context); // Close the dialog after applying filter
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyFilter() {
    String fromDate = _fromDateController.text;
    String toDate = _toDateController.text;

    setState(() {
      filteredList = dataList.where((item) {
        DateTime itemDate = DateFormat('yyyy-MM-dd').parse(item.date);
        DateTime? fromDateParsed =
        fromDate.isNotEmpty ? DateFormat('yyyy-MM-dd').parse(fromDate) : null;
        DateTime? toDateParsed =
        toDate.isNotEmpty ? DateFormat('yyyy-MM-dd').parse(toDate) : null;

        if (fromDateParsed != null && toDateParsed != null) {
          return itemDate.isAfter(fromDateParsed.subtract(Duration(days: 1))) &&
              itemDate.isBefore(toDateParsed.add(Duration(days: 1)));
        } else if (fromDateParsed != null) {
          return itemDate.isAfter(fromDateParsed.subtract(Duration(days: 1)));
        } else if (toDateParsed != null) {
          return itemDate.isBefore(toDateParsed.add(Duration(days: 1)));
        } else {
          return true;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            icon: Icon(Icons.filter_list_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35).copyWith(top: 20),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(filteredList[index].title),
                    Text("${filteredList[index].date} ${filteredList[index].time}"),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(filteredList[index].description),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Edit'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: filteredList.length,
        ),
      ),
    );
  }
}

class DataModel {
  String title;
  String date;
  String time;
  String description;

  DataModel({
    required this.title,
    required this.date,
    required this.time,
    required this.description,
  });
}
