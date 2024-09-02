/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../common_widgets.dart';
import 'create_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController dateCon = TextEditingController();
  List<DataModel> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadDataList();
  }
  // void _navigateToCreateScreen(DataModel? dataModel) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CreateScreen(),
  //     ),
  //   );
  //   _loadDataList(); // Reload the data after returning
  // }

  // Load data from SharedPreferences
  void _loadDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataListString = prefs.getString('dataList');
    if (dataListString != null) {
      List<dynamic> jsonList = json.decode(dataListString);
      setState(() {
        dataList = jsonList.map((json) => DataModel.fromJson(json)).toList();
      });
    }
  }

  // Apply filter based on the selected date
  void _filterDataList() {
    final selectedDate = dateCon.text;
    if (selectedDate.isEmpty) {
      _loadDataList(); // Reload the full list if no date is selected
      return;
    }

    final filteredList = dataList.where((item) {
      final itemDate = DateFormat('yyyy-MM-dd').parse(item.startDate);
      final selectedDateParsed = DateFormat('yyyy-MM-dd').parse(selectedDate);

      return itemDate.isAtSameMomentAs(selectedDateParsed);
    }).toList();

    setState(() {
      dataList = filteredList;
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Color(0xffFD7418)),
                controller: dateCon,
                decoration: InputDecoration(
                  hintText: 'Date',
                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Color(0xffFD7418)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                  suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateCon.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                readOnly: true,
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _filterDataList(); // Apply the filter
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Color(0xffFD7418),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: CommonWidgets.textWidget(data: 'Apply', fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text('Are you sure you want to delete this activity?', textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff9F9F9F)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CommonWidgets.textWidget(data: 'No'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFD7418)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
            ),
            onPressed: () {
              setState(() {
                dataList.removeAt(index);
                // _saveDataList(); // Save the updated list
              });
              Navigator.of(context).pop();
            },
            child: CommonWidgets.textWidget(data: 'Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xffFD7418),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: CommonWidgets.textWidget(data: 'My To-Do List'),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            icon: Icon(
              Icons.filter_list_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35).copyWith(top: 20),
          child: dataList.isEmpty
              ? Center(
            child: CommonWidgets.textWidget(data: 'No To-do found'),
          )
              : ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.3),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 19),
                      title: Text(
                        dataList[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Day Type :',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                dataList[index].dayType,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          dataList[index].dayType == 'Multiple'
                              ? Text(
                            "${dataList[index].startDate} - ${dataList[index].endDate}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              : Text(
                            "${dataList[index].startDate} at ${dataList[index].time}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          dataList[index].dayType == 'Multiple'
                              ? Text(
                            "${dataList[index].time} to ${dataList[index].endTime}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => CreateScreen(),
                                  ),
                                );

                              },
                              child: CommonWidgets.textWidget(
                                data: 'Edit',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            width: 1,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _showDeleteDialog(index);
                              },
                              child: CommonWidgets.textWidget(
                                data: 'Delete',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DataModel {
  final String title;
  final String time;
  final String description;
  final String startDate;
  final String endDate;
  final String endTime;
  final String dayType;

  DataModel({
    required this.title,
    required this.time,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.endTime,
    required this.dayType,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      endTime: json['endTime'] ?? '',
      dayType: json['dayType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'endTime': endTime,
      'dayType': dayType,
    };
  }
}


*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../common_widgets.dart';
import 'create_screen.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController dateCon = TextEditingController();
  List<DataModel> dataList = [];

  @override
  void initState() {
    super.initState();
    _loadDataList();
  }

  // void _navigateToCreateScreen(DataModel? dataModel) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CreateScreen(dataModel: dataModel),
  //     ),
  //   );
  //   _loadDataList(); // Reload the data after returning
  // }

  // Load data from SharedPreferences
  void _loadDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataListString = prefs.getString('dataList');
    if (dataListString != null) {
      List<dynamic> jsonList = json.decode(dataListString);
      setState(() {
        dataList = jsonList.map((json) => DataModel.fromJson(json)).toList();
      });
    }
  }

  // Apply filter based on the selected date
  void _filterDataList() {
    final selectedDate = dateCon.text;
    if (selectedDate.isEmpty) {
      _loadDataList(); // Reload the full list if no date is selected
      return;
    }

    final filteredList = dataList.where((item) {
      final itemDate = DateFormat('yyyy-MM-dd').parse(item.startDate);
      final selectedDateParsed = DateFormat('yyyy-MM-dd').parse(selectedDate);

      return itemDate.isAtSameMomentAs(selectedDateParsed);
    }).toList();

    setState(() {
      dataList = filteredList;
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Color(0xffFD7418)),
                controller: dateCon,
                decoration: InputDecoration(
                  hintText: 'Date',
                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Color(0xffFD7418)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                  suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xffFD7418))),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateCon.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                readOnly: true,
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _filterDataList(); // Apply the filter
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Color(0xffFD7418),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: CommonWidgets.textWidget(data: 'Apply', fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text('Are you sure you want to delete this activity?', textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff9F9F9F)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CommonWidgets.textWidget(data: 'No'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFD7418)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
            ),
            onPressed: () {
              setState(() {
                dataList.removeAt(index);
                _saveDataList(); // Save the updated list
              });
              Navigator.of(context).pop();
            },
            child: CommonWidgets.textWidget(data: 'Yes'),
          ),
        ],
      ),
    );
  }

  void _saveDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(dataList.map((data) => data.toJson()).toList());
    prefs.setString('dataList', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xffFD7418),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: CommonWidgets.textWidget(data: 'My To-Do List'),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            icon: Icon(
              Icons.filter_list_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35).copyWith(top: 20),
          child: dataList.isEmpty
              ? Center(
            child: CommonWidgets.textWidget(data: 'No To-do found'),
          )
              : ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.3),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 19),
                      title: Text(
                        dataList[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Day Type :',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                dataList[index].dayType,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          dataList[index].dayType == 'Multiple'
                              ? Text(
                            "${dataList[index].startDate} - ${dataList[index].endDate}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              : Text(
                            "${dataList[index].startDate} at ${dataList[index].time}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          dataList[index].dayType == 'Multiple'
                              ? Text(
                            "${dataList[index].time} to ${dataList[index].endTime}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => CreateScreen(
                                      dataModel: dataList[index],

                                    ),
                                  ),
                                ).then((_) {
                                  _loadDataList(); // Reload the data after returning
                                });                              },
                              child: CommonWidgets.textWidget(
                                data: 'Edit',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            width: 1,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _showDeleteDialog(index);
                              },
                              child: CommonWidgets.textWidget(
                                data: 'Delete',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/*
class DataModel {
  final String title;
  final String time;
  final String description;
  final String startDate;
  final String endDate;
  final String endTime;
  final String dayType;

  DataModel({
    required this.title,
    required this.time,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.endTime,
    required this.dayType,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      endTime: json['endTime'] ?? '',
      dayType: json['dayType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'endTime': endTime,
      'dayType': dayType,
    };
  }
}
*/
