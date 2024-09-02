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
      title: json['title'],
      time: json['time'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      endTime: json['endTime'],
      dayType: json['dayType'],
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
