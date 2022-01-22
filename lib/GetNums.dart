import 'package:flutter/material.dart';
import 'utilfuncs.dart';

class GetNums extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return _GetNumsState();
  }

}

class _GetNumsState extends State<GetNums>{
  Future<Map<String, dynamic>> futureNums;
  static var style = TextStyle(fontSize: 20);
  @override
  void initState(){
    super.initState();
    futureNums = fetchNums();
  }
  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder(
        future: futureNums,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return
              Center(
                  child: Text("${snapshot.data['draw_no']}회차 \n${snapshot.data['numbers'][0]} ${snapshot.data['numbers'][1]} ${snapshot.data['numbers'][2]} ${snapshot.data['numbers'][3]} ${snapshot.data['numbers'][4]} ${snapshot.data['numbers'][5]} 보너스는 ${snapshot.data['bonus_no']}", style: style)
              );
          }
          else if(snapshot.hasError){
            return Center(child: Text("오류가 발생했습니다. 인터넷 되나요?", style: style,),);
          }

          return
            Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                )
            );
        }
    );
  }
}