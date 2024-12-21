import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/joke.dart';
import '../providers/joke_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/header.dart';

class FavoritesJokesScreen extends StatefulWidget{
  const FavoritesJokesScreen({super.key});

  @override
  State<FavoritesJokesScreen> createState() => _JokesState();

}
class _JokesState extends State<FavoritesJokesScreen>{

  @override
  Widget build(BuildContext context) {
    final jokeProvider=Provider.of<JokeProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(),
      body:Column(
        children: [
          Header(text: "Favorites jokes".toUpperCase()),
          (jokeProvider.favorites.length==0)?
          Center(child: const Text("No favorites..",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),)):
          Expanded(child: ListView.builder(
            itemCount: jokeProvider.favorites.length,
            itemBuilder: (context, index) {
              final item = jokeProvider.favorites[index];
              return ListTile(
                title: Text(item.setup),
                subtitle: Text(item.punchline,style: const TextStyle(color: Colors.green)),
                leading:
                IconButton(
                    icon: Icon(Icons.favorite),
                    color: Colors.red,
                    onPressed: () {
                      jokeProvider.removeFavoriteJoke(item);
                    }
                )
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