import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List api_response=[];
  int selectedIndex=0;
  void _incrementCounter() {
   fetchData();
    
  }

  Future fetchData() async {
  final response = await http
      .get(Uri.parse('https://aws.rishabh.live/api/smit-whatsmydp/db/records.new.json'));

  if (response.statusCode == 200) {
    setState(() {
      api_response=jsonDecode(response.body);
    });
   
  //  print(api_response);
  } else {
    throw Exception('Failed to load album');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Response'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: ListView.builder(
          itemCount:api_response.length,
          itemBuilder: (context,index){
            return Card(
                    elevation: 10,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        selectedIndex=index;
                      });
                    },
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(10),
                      height: selectedIndex==index?200:100,
                      duration: Duration(milliseconds: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              Spacer(),
                              
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                     text: 'Username: ' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black)
                                    ),
                                    TextSpan(
                                      text: api_response[index]['username'],style: TextStyle(color: Colors.black,fontSize: 18,)
                                    )
                                  ]
                                )
                              ),
                              Visibility(
                                visible: selectedIndex==index,
                                child: Spacer()
                              ),
                              Text('Visits: '+api_response[index]['visits'].toString(),style: TextStyle(color: Colors.green),textAlign: TextAlign.start,),
                              Spacer(),
                              Visibility(
                                visible: selectedIndex==index,
                                child: Text('Noise: '+api_response[index]['noise'])
                              ),
                              Spacer(),
                              Visibility(
                                visible: selectedIndex==index,
                                child: Text('Access Token: '+api_response[index]['accessToken'].toString().substring(0,25)+'...')
                              ),
                              Spacer(),
                              Visibility(
                                visible: selectedIndex==index,
                                child: SizedBox(width: 300, child: Text('Refresh Token: '+api_response[index]['refreshToken'].toString(),overflow: TextOverflow.clip,maxLines: 1,))
                              ),
                              Spacer(),
                              Visibility(
                                visible: selectedIndex==index,
                                child: Text('CSRF Token: '+api_response[index]['csrfToken'].toString().substring(0,25)+'...')
                              ),
                              

                            ],
                          ),
                          
                        ],
                      ),
                    ),
                  ),
              );
          }
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
