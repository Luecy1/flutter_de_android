import 'package:flutter/material.dart';
import 'package:flutter_de_android/station.dart';
import 'package:flutter_de_android/station_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final stationRepository = StationRepository();

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

        final size = MediaQuery.of(context).size.width * 0.6;
        final station = stationList[index ~/ 2];

        return ListTile(
          title: Text(
            stationList[index ~/ 2].name,
            style: TextStyle(fontSize: 22.0),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => FutureBuilder(
                future: stationRepository.getCheckInStatus(station.id),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  final hasData = snapshot.hasData;
                  if (!hasData) {
                    return loadingWidget();
                  }
                  if (snapshot.data) {
                    return stationDialog(context, size, station, true);
                  }

                  return stationDialog(context, size, station, false);
                },
              ),
            ).then((checkIn) {
              if (checkIn != null && checkIn) {
                stationRepository.saveCheckInStation(stationList[index ~/ 2].id);
              }
            });
          },
        );
      },
    );
  }

  Widget stationDialog(
    final BuildContext context,
    final double size,
    final Station station,
    final bool checkIn,
  ) {
    final List<Widget> actions = [];
    final List<Widget> title = [
      Text(
        station.name,
        style: TextStyle(color: Colors.black, fontSize: 22.0),
      )
    ];

    if (checkIn) {
      title.add(Icon(
        Icons.check_circle,
        color: Colors.green,
      ));
    } else {
      actions.add(FlatButton(
        child: Text('チェックイン'),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ));
    }

    return AlertDialog(
      title: Row(
        children: title,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      content: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(station.image),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
