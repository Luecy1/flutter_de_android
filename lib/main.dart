import 'package:flutter/material.dart';
import 'package:flutter_de_android/station.dart';
import 'package:flutter_de_android/station_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationRepository = StationRepository();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Station List'),
        ),
        body: FutureBuilder(
          future: stationRepository.getStations(),
          builder: (context, AsyncSnapshot<List<Station>> snapshot) {
            final hasData = snapshot.hasData;

            if (!hasData) {
              return loadingWidget();
            }

            return stationListView(snapshot.data);
          },
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        width: 32.0,
        height: 32.0,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget stationListView(final List<Station> stationList) {
    return ListView.builder(
      itemCount: stationList.length * 2,
      itemBuilder: (context, final index) {
        if (index.isOdd) {
          return Divider(color: Colors.blue);
        }

        return ListTile(
          title: Text(
            stationList[index ~/ 2].name,
            style: TextStyle(fontSize: 22.0),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
