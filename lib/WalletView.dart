import 'package:flutter/material.dart';
// Utility functions
import 'utilfuncs.dart';

class Wallet extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _WalletState();
  }
}


class _WalletState extends State<Wallet>{
  List<Map> data = [];
  Future<void> getData() async{
    data = await db.rawQuery(
        "SELECT * FROM lotto"
    );

  }
  Future<void> deleteData(int index) async {
    if(await getCount() == 1){
      await db.rawDelete("DELETE FROM lotto");
    }
    else {
      await db.rawDelete("DELETE FROM lotto WHERE id=$index");
    }
  }


  @override
  Widget build(BuildContext context){
    getData();
    return

      ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) =>
          const Divider(),
        itemBuilder: (BuildContext context, int index){
          final item = data[index]['value'];
          return
            Column(
                children: <Widget>[
                  Dismissible(

                    // Show a red background as the item is swiped away.
                    background: Container(color: Colors.red),
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      deleteData(index);
                      setState(() {
                        data.removeAt(index);

                      });
                      setState(() {
                        
                      });
                    },
                    child: ListTile(title: Text('$item'), subtitle: Text('${data[index]['date']}'),),
                  ),

                ]
            );
        },

      );
  }
}