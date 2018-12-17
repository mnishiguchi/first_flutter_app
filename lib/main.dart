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
      home: RandomWordListScreen(),
    );
  }
}

class RandomWordListScreen extends StatefulWidget {
  @override
  _RandomWordListScreenState createState() => _RandomWordListScreenState();
}

class _RandomWordListScreenState extends State<RandomWordListScreen> {
  final _wordList = <WordPair>[];
  final _savedWordSet = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Word List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return SavedWordScreen(
                    wordSet: _savedWordSet,
                  );
                }),
              );
            },
          )
        ],
      ),
      body: _buildSuggestionListView(),
    );
  }

  Widget _buildSuggestionListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final itemIndex = i ~/ 2;

        if (itemIndex >= _wordList.length) {
          _wordList.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_wordList[itemIndex]);
      },
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final isAlreadySaved = _savedWordSet.contains(wordPair);
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        isAlreadySaved ? Icons.favorite : Icons.favorite_border,
        color: isAlreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (isAlreadySaved) {
            _savedWordSet.remove(wordPair);
          } else {
            _savedWordSet.add(wordPair);
          }
        });
      },
    );
  }
}

class SavedWordScreen extends StatelessWidget {
  const SavedWordScreen({Key key, this.wordSet}) : super(key: key);

  final Set<WordPair> wordSet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Words'),
      ),
      body: _SavedWordListView(wordSet: wordSet),
    );
  }
}

class _SavedWordListView extends StatelessWidget {
  const _SavedWordListView({Key key, this.wordSet}) : super(key: key);

  final Set<WordPair> wordSet;

  @override
  Widget build(BuildContext context) {
    final List<WordPair> suggestions = wordSet.toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestions[index].asPascalCase,
            style: TextStyle(fontSize: 18.0),
          ),
        );
      },
    );
  }
}
