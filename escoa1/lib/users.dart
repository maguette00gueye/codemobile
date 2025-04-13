import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class utilisateurs extends StatefulWidget {
  const utilisateurs({super.key});

  @override
  State<utilisateurs> createState() => _utilisateursState();
}

class _utilisateursState extends State<utilisateurs> {
  
  Future mya ()async {
    final response = await http.get(Uri.parse('https://http://localhost/projetmemoire/senresto/all_ff.php'));
    print(response.body);
    if (response.statusCode==200)
      {
       setState(() {
         maguii=jsonDecode(response.body);
       });
      }
  }
  Map? maguii;
  @override
  void initState() {
    mya();
    // TODO: implement initState
    super.initState();
  }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount:maguii!['data'].length,itemBuilder:  (context, index){
        return ListTile(
          title: Column(
            children: [
              Text(maguii!['data'][index]['email']),  Text(maguii!['data'][index]['id'].toString()),
            ],
          ),
          subtitle: Image.network(maguii!['data'][index]['avatar']),
          leading: Column(
            children: [
              Text(maguii!['data'][index]['last_name']),
              Text(maguii!['data'][index]['first_name']),
            ],
          ),
        );

      }),
    );
  }
}
