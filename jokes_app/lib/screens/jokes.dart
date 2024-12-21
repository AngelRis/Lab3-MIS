import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/models/joke.dart';
import 'package:jokes_app/providers/joke_provider.dart';
import 'package:jokes_app/widgets/app_bar.dart';
import 'package:jokes_app/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import '../services/api_services.dart';
import '../widgets/header.dart';

class JokesScreen extends StatefulWidget{
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesState();

}
class _JokesState extends State<JokesScreen>{
  List<Joke> jokes=[];
  String type="";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as String;
    setState(() {
      type = arguments;
    });
    if (type.isNotEmpty) {
      getAllJokesForTypeApi(type);
    }
  }

  void getAllJokesForTypeApi(String type) async {
    ApiService.getAllJokesForTypeFromAPI(type).then((response) {
      var data = List.from(json.decode(response.body));
      setState(() {
        jokes = data.asMap().entries.map<Joke>((element) {
          return Joke.fromJson(element.value);
        }).toList();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final jokeProvider=Provider.of<JokeProvider>(context);
    return Scaffold(
        appBar: AppBarWidget(),
        body:Column(
          children: [
            Header(text: "$type type jokes".toUpperCase()),
            Expanded(child: ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final item = jokes[index];
                return ListTile(
                  title: Text(item.setup),
                  subtitle: Text(item.punchline,style: const TextStyle(color: Colors.green)),
                  leading:(jokeProvider.favorites.any((tmp)=>tmp.id==item.id))? 
                  IconButton(
                      icon: Icon(Icons.favorite),
                      color: Colors.red,
                      onPressed: () {
                        jokeProvider.removeFavoriteJoke(item);

                      }
               ):
                  IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        jokeProvider.addFavoriteJoke(item);
                      })
                  ,
                  trailing: Text("ID: ${item.id}"),
                );
              },
            ),
            ),
          ],
        ),

      bottomNavigationBar: BottomBarWidget(),

    );
  }
}