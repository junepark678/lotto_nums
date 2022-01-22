import 'package:flutter/material.dart';
import 'dart:math';

// Utility functions
import 'utilfuncs.dart';

// GetNums widget
import 'GetNums.dart';

// Wallet widget
import 'WalletView.dart';

//qr code reader widget
import 'qrscan.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mkdatabase();
    return MaterialApp(
      title: 'My Flutter App',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>
    with AutomaticKeepAliveClientMixin<Home>, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  var rng = new Random();
  static var style = TextStyle(fontSize: 20);
  Widget text = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[Text("숫자를 생성하려면 아래 + 버튼을 눌러주세요.", style: style)],
    ),
  );

  int nextNum1;
  int nextNum2;
  int nextNum3;
  int nextNum4;
  int nextNum5;
  int nextNum6;
  int nextNum7;



  Future<void> handleClick(String value) async {
    switch (value) {
      case '지갑 지우기':
        resetData();
        await sleep1();
        setState(() {});
        break;
      case '직접 입력':
        _showDialog();
        break;
    }
    setState(() {});
  }

  _showDialog() async {
    final myController = TextEditingController();
    Widget textfield = new TextField(
      controller: myController,
      autofocus: true,
      decoration: new InputDecoration(labelText: '로또 숫자'),
    );
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: textfield,
                )
              ],
            ),
            actions: <Widget>[
              new TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new TextButton(
                  child: const Text('입력'),
                  onPressed: () {
                    addToWallet(myController.text);
                    setState(() {});
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget tabs = DefaultTabController(
        length: 4,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              setState(() {});
            }
          });
          return Scaffold(
              appBar: AppBar(
                title: Text('로또 숫자 자판기'),
                bottom: TabBar(tabs: [
                  Tab(icon: Icon(Icons.add)),
                  Tab(icon: Icon(Icons.wallet_membership)),
                  Tab(icon: Icon(Icons.language)),
                  Tab(icon: Icon(Icons.qr_code_scanner_rounded),)
                ]),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: PopupMenuButton<String>(
                      onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'직접 입력'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  nextNum1 = rng.nextInt(45) + 1;

                  nextNum2 = rng.nextInt(45) + 1;
                  while (nextNum1 == nextNum2) {
                    nextNum2 = rng.nextInt(45) + 1;
                  }
                  nextNum3 = rng.nextInt(45) + 1;
                  while (nextNum2 == nextNum3) {
                    nextNum3 = rng.nextInt(45) + 1;
                  }
                  nextNum4 = rng.nextInt(45) + 1;
                  while (nextNum3 == nextNum4) {
                    nextNum4 = rng.nextInt(45) + 1;
                  }
                  nextNum5 = rng.nextInt(45) + 1;
                  while (nextNum4 == nextNum5) {
                    nextNum5 = rng.nextInt(45) + 1;
                  }
                  nextNum6 = rng.nextInt(45) + 1;
                  while (nextNum5 == nextNum6) {
                    nextNum6 = rng.nextInt(45) + 1;
                  }
                  /*nextNum7 = rng.nextInt(45)+1;
                  while(nextNum6 == nextNum7){
                    nextNum7 = rng.nextInt(45)+1;
                  }*/
                  setState(() {
                    text = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("숫자는: ", style: style),
                          Text(
                              "$nextNum1, $nextNum2, $nextNum3, $nextNum4, $nextNum5, $nextNum6입니다.",
                              style: style),
                          //Text("보너스는: $nextNum7입니다.", style: Style)
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('지갑에 보관되었습니다.'),
                                duration: const Duration(seconds: 1),
                              ));
                              addToWallet(
                                  "$nextNum1, $nextNum2, $nextNum3, $nextNum4, $nextNum5, $nextNum6");
                            },
                            child: Text('지갑에 넣기'),
                          )
                        ],
                      ),
                    );
                  }); // setState Lambda
                }, // onPressed Lambda
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
              body: TabBarView(children: [
                text,
                Wallet(),
                GetNums(),
                QRViewExample(),
              ]));
        }));

    return MaterialApp(title: '로또 숫자 제판기', home: tabs);
  }
}
