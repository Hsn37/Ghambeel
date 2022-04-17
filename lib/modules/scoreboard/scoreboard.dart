import 'dart:async';
import 'dart:convert';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../utils.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';


class topBar extends AppBar {
    final String myTitle;
    topBar({Key? key, required BuildContext context,required this.myTitle})
    : super(
        key: key,
        leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryText[darkMode], ),
              onPressed: () {
                var currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                  Navigator.pop(
                    context,
                );
            }
        ),
      title: Text('Daily Leaderboard',style: TextStyle(color: primaryText[darkMode]),),
      
      backgroundColor: bg[darkMode],
    );
}
class Leaderboard extends StatefulWidget{
  const Leaderboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LeaderboardState createState() => _LeaderboardState();
}
class _LeaderboardState extends State<Leaderboard>{
  var topNum = 5;
  var toDisplay = 0;
  var maxShow = 50;
  // Map<dynamic, dynamic>? scores;
  List<dynamic> rawscores = [];
  List<dynamic> scores = [];
  String username = "";
  void syncScores () async {
    rawscores = await getScores();
    print(rawscores);

    setState(() {
      rawscores.sort((s2, s1) {
        return Comparable.compare(s1["score"], s2["score"]);
      });
    });


    scores = rawscores.take(topNum).toList();
    final prefs = await SharedPreferences.getInstance();
    setState(()  {
      toDisplay = scores.length;
      topNum = min(toDisplay, topNum);
      maxShow = min(50, rawscores.length);
      username = prefs.getString('username')!;
    });
    print(scores);
    isInit = false;
  }

  void initState() {
    super.initState();
    syncScores();
  }

  Widget makeCard(String str1, flag,score) {
    var initials=str1[0];
    var bytes = utf8.encode(str1);
    var digest = sha1.convert(bytes);
    var color = Color(((digest.bytes.sum * digest.bytes.sum)%9000000 * 0xFFFFFF).toInt()).withOpacity(1.0);
      return Card ( //static cos otherwise implicit declaration
         // elevation: 8.0,
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30), ),
          shadowColor:lightPrimary[darkMode], // const Color.fromARGB(0, 0, 255, 255),
          //color: Colors.red,
          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
          child: Container(
          decoration: BoxDecoration(color: bg[darkMode],borderRadius:BorderRadius.all(Radius.circular(50.0)),
            boxShadow:  [
              BoxShadow(color: (username == str1) ? accent : bg[darkMode], spreadRadius: 3),
            ],),// function call check task urgency, select and return color!!!
          child:Container(
              decoration:  BoxDecoration(color: listTileCol[darkMode], borderRadius:  const BorderRadius.all(Radius.circular(50))),
            child: makeTileU(str1,initials,score,color),
          ),
        ),
      );
    
    
  }
  Widget makeTileU(String str1,String initials, String Score,Color coloftile){


   return ListTile ( 
    //  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10.0),
      selectedColor: coloftile,
      selectedTileColor: coloftile,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50), ),
  
      leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            
            border: Border.all(
              color: coloftile,
            ),
            color: coloftile,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Text(initials,style:TextStyle(color:primaryText[0],fontSize: 28)),
            ],
          )
      ),
      title: Row(
        children: <Widget>[ // this needs to have task header!!!!! sample text here
          Text(str1, style: TextStyle(color: primaryText[darkMode], fontSize: 16)),
          const SizedBox(width: 2,),
        ]
      ),
      trailing: Text(Score, style: TextStyle(color:primaryText[darkMode])),
    );     
  }
  
  var isInit = true;
  var isLoading = false;

   Widget makeBody() {
    return 
    // uncomment beow line of code to check if data has been fetched. laoding screen laoded else call fetch data function

    isInit ?
      Center(
        child: Loading(),
      )
      :

     SafeArea(
          child: Container(

            child: Container(
              child:ListView(
                children:[
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child:  Text("A healthy competition goes a long way!",style: TextStyle(color: subtleGrey )),
                  ),
                   Padding(
                    padding: EdgeInsets.all(24),
                    child:  Text("Select number of top scorers:",style: TextStyle(color: primaryText[darkMode] )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                      child:NumberPicker(
                    value: topNum,
                    minValue: 0,
                    maxValue: maxShow,
                    itemCount: 6,
                    step: 1,
                    itemHeight: 25,
                    itemWidth: 73,
                    axis: Axis.horizontal,
                    textStyle: TextStyle(color:primaryText[darkMode]),
                    selectedTextStyle: TextStyle(color:accent),
                    onChanged: (value) => setState(
                            () {topNum = value;
                            syncScores();}
                    ),
                  ),),
                  Container(
                  padding: EdgeInsets.all(14),
                   margin: EdgeInsets.all(35),
                    decoration:  BoxDecoration(
                     color: bg[darkMode],
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text("Username", style: TextStyle(color:primaryText[darkMode])),
                           Text("Score", style: TextStyle(color:primaryText[darkMode]))
                          //Text("Rankings")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (int i=0; i<toDisplay; i++)
                        makeCard( (scores.length > i) ? scores[i]["username"] : "",true,(scores.length > i) ? scores[i]["score"].toString() : ""),
                       //
                       // makeCard("maaz",true,"4.4"),
                       //  makeCard("maaz",true,"4.4"),
                       //   makeCard("maaz",true,"4.4"),
                       //    makeCard("maaz",true,"4.4"),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     makeCard("maaz",true),
                      //     makeCard("4.5",false),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     makeCard("msashskjz",true),
                      //     makeCard("4.3",false),
                      //   ],
                      // ),



                    ],
                  )
                  


                  )






                ],
              ),
              
              
            )
          ),
        
      );
   }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: topBar(context: context, myTitle: '',),
      backgroundColor: bg[darkMode],
      body: makeBody(),
    );
  }
  
}