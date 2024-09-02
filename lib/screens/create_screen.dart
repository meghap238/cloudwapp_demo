
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../common_widgets.dart';
import 'home_screen.dart';
import 'model.dart';

class CreateScreen extends StatefulWidget {
  final DataModel? dataModel;
  final int? index;

  CreateScreen({this.dataModel, this.index});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _endtimeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController daytypeCon = TextEditingController();

  List<DataModel> dataList = [];
  bool light = true;
  String dayType = 'Multiple';


  @override
  void initState() {
    super.initState();
    _loadDataList();
    if (widget.dataModel != null) {
      _titleController.text = widget.dataModel!.title;
      _timeController.text = widget.dataModel!.time;
      _endtimeController.text = widget.dataModel!.endTime;
      _startDateController.text = widget.dataModel!.startDate;
      _endDateController.text = widget.dataModel!.endDate;
      _descriptionController.text = widget.dataModel!.description;
      dayType = widget.dataModel!.dayType;
      light = dayType == 'Multiple';
    }
  }


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

  void _saveDataList() async {
    if (widget.index != null) {

      dataList[widget.index!] = DataModel(
        title: _titleController.text,
        time: _timeController.text,
        description: _descriptionController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        endTime: _endtimeController.text,
        dayType: dayType,
      );
    } else {

      dataList.add(DataModel(
        title: _titleController.text,
        time: _timeController.text,
        description: _descriptionController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        endTime: _endtimeController.text,
        dayType: dayType,
      ));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataListString = json.encode(dataList.map((data) => data.toJson()).toList());
    prefs.setString('dataList', dataListString);
    print(dataListString);
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: 'poppins',
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: 'poppins',
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDayTypeField() {
    return TextFormField(
      controller: daytypeCon,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: 'poppins',
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Day Type',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: 'poppins',
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CommonWidgets.textWidget(data: 'Single'),
            Switch(
              value: light,
              activeTrackColor: Colors.white.withOpacity(0.5),
              thumbColor: MaterialStatePropertyAll(Colors.green),
              inactiveTrackColor: Colors.white.withOpacity(0.5),
              onChanged: (bool value) {
                setState(() {
                  light = value;
                  dayType = light ? 'Multiple' : 'Single';
                });
              },
            ),
            CommonWidgets.textWidget(data: 'Multiple'),
            SizedBox(width: 5),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDateTimeFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _timeController,
          hintText: 'Start Time',
          validator: (value) => value == null || value.isEmpty ? 'Please enter a start time' : null,
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: _endtimeController,
          hintText: 'End Time',
          validator: (value) => value == null || value.isEmpty ? 'Please enter an end time' : null,
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: _startDateController,
          hintText: 'Start Date',
          validator: (value) => value == null || value.isEmpty ? 'Please enter a start date' : null,
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: _endDateController,
          hintText: 'End Date',
          validator: (value) => value == null || value.isEmpty ? 'Please enter an end date' : null,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: 'poppins',
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Description',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: 'poppins',
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      maxLines: 3,
      validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 20),
        ),
        title: CommonWidgets.textWidget(data: 'My To-Do List'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 110, left: 20, right: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/background.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: daytypeCon,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Day Type',
                    hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CommonWidgets.textWidget(data: 'Single'),
                        Switch(
                          value: light,
                          activeTrackColor: Colors.white.withOpacity(0.5),
                          thumbColor: MaterialStatePropertyAll(Colors.green),
                          inactiveTrackColor: Colors.white.withOpacity(0.5),
                          onChanged: (bool value) {
                            setState(() {
                              light = value;
                              dayType = light ? 'Multiple' : 'Single';
                            });
                          },
                        ),
                        CommonWidgets.textWidget(data: 'Multiple'),
                        SizedBox(width: 5),
                      ],
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a start date';
                          }
                          return null;
                        },
                        controller: _startDateController,
                        decoration: InputDecoration(
                          hintText: 'Start Date',
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
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
                              _startDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                        controller: _timeController,
                        decoration: InputDecoration(
                          hintText: 'Start Time',
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: Icon(Icons.watch_later_outlined, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a time';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                light
                    ? Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                        controller: _endDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an end date';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'End Date',
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
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
                              _endDateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                        controller: _endtimeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an end time';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'End Time',
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: Icon(Icons.watch_later_outlined, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'poppins', color: Colors.white),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _saveDataList();
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xffFD7418), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    // child: CommonWidgets.textWidget(data: 'Create', fontSize: 20),
                    child: CommonWidgets.textWidget(data: widget.index != null ? 'Update' : 'Create', fontSize: 20),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


