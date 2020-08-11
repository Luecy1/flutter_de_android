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
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => stationDialog(
                MediaQuery.of(context).size.width * 0.6,
                stationList[index ~/ 2].name,
                stationList[index ~/ 2].image,
              ),
            );
          },
        );
      },
    );
  }

  Widget stationDialog(final double size, final String name, final String url) {
    return AlertDialog(
      title: Text(
        name,
        style: TextStyle(color: Colors.black, fontSize: 22.0),
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(url),
          ),
        ),
      ),
    );
  }
}
