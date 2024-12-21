import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/widgets/app_bar.dart';
import 'package:jokes_app/widgets/bottom_bar.dart';
import 'package:jokes_app/widgets/header.dart';
import 'package:jokes_app/widgets/joke_type_card.dart';


import '../services/api_services.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

}
class _HomeState extends State<Home>{
  List<String> types=[];
  @override
  void initState() {
    super.initState();
    getTypesFromApi();
  }
  void getTypesFromApi() async {
    ApiService.getTypesFromAPI().then((response) {
      var data = List.from(json.decode(response.body));
      setState(() {
          types= List<String>.from(data);
        });
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body:Column(
        children: [
          const Header(text: "Choose a joke type"),
          Expanded(child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(15),
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            childAspectRatio: 0.8,
            physics: const BouncingScrollPhysics(),
            children: types.map((type)=>JokeTypeCard(type: type)).toList(),

          )
          )
        ],
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}