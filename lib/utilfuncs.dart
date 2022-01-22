import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
Database db;

Future<void> mkdatabase() async {
  db = await openDatabase('lotto.db', version: 1, onCreate: (Database db, int version) async{
    await db.execute(
        'CREATE TABLE lotto(id INTEGER PRIMARY KEY, value TEXT NOT NULL UNIQUE, date TEXT);'
    );
  });

}


Future<Map<String, dynamic>> fetchNums() async {
  final response = await http.get(Uri.dataFromString('https://smok95.github.io/lotto/results/latest.json'));
  assert (response.statusCode == 200);
  return jsonDecode(response.body);
}

Future<String> fetchfromqr(String link) async {
  final response = await http.get(Uri.dataFromString(link));
  assert (response.statusCode == 200);
  var document = parse(response.body);
  String toReturn = "";

  var clrs = document.getElementsByClassName("clr");

  assert(clrs.length >= 6);

  int num1, num2, num3, num4, num5, num6;


  num1 = int.parse(clrs[0].text);
  num2 = int.parse(clrs[1].text);
  num3 = int.parse(clrs[2].text);
  num4 = int.parse(clrs[3].text);
  num5 = int.parse(clrs[4].text);
  num6 = int.parse(clrs[5].text);

  toReturn = "$num1, $num2, $num3, $num4, $num5, $num6";

  return toReturn;
}

Future<int> getCount() async {
  //database connection
  var x = await db.rawQuery('SELECT COUNT (*) from lotto');
  int count = Sqflite.firstIntValue(x);
  return count;
}
Future<void> resetData() async{
  await db.execute(
      'DELETE FROM lotto'
  );
}

Future<void> addToWallet(String num) async {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  await db.rawInsert(
      "INSERT INTO lotto(value, date) VALUES(?, ?)", [num, formattedDate]);
}