
class ListDataModel{
  final String title;
  final String discription;
  final String date;
  final String time;

  ListDataModel( { required this.title, required this.discription, required this.date,required this.time, });

}

List<ListDataModel> dataList = [
  ListDataModel(
    title: 'rose',
    discription: "rose is flower.. ",
    date: '15-08-2024',
    time: "55:30"
  ),

];