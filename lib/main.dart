import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Flutter App',
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => new _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestionList = <WordPair>[];
  final _savedSuggestionSet = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Flutter App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSavedSuggestion,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSavedSuggestion() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        final Iterable<ListTile> tiles =
            _savedSuggestionSet.map((WordPair wordPair) {
          return ListTile(
            title: Text(
              wordPair.asPascalCase,
              style: _biggerFont,
            ),
          );
        });

        final List<Widget> dividedTiles = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Sugggestions'),
          ),
          body: ListView(children: dividedTiles),
        );
      }),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final itemIndex = i ~/ 2;

        if (itemIndex >= _suggestionList.length) {
          _suggestionList.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestionList[itemIndex]);
      },
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final isAlreadySaved = _savedSuggestionSet.contains(wordPair);
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        isAlreadySaved ? Icons.favorite : Icons.favorite_border,
        color: isAlreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (isAlreadySaved) {
            _savedSuggestionSet.remove(wordPair);
          } else {
            _savedSuggestionSet.add(wordPair);
          }
        });
      },
    );
  }
}
