import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ndialog/ndialog.dart';
import 'package:proyecto_final/firebase/teams_firebase.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  TeamsFirebase? _placesFirebase;
  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _placesFirebase = TeamsFirebase();
    /*AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'key1',
          channelName: 'Mundial',
          channelDescription: "Team Topic",
          defaultColor: Color(0XFF9050DD), 
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true 
        )

      ]
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciones que participan'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: StreamBuilder(
        stream: _placesFirebase!.getAllTeams(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var team = snapshot.data!.docs[index];
                return ListTile(
                  leading: Image.network(team.get('TeamLogo')),
                  title: Text(team.get('TeamName') +
                      '    ' +
                      team.get('IdTeam').toString()),
                  subtitle: Text(team.get('TeamShort')),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(children: [
                      if (team.get('TeamShort') == "MEX" ||
                          team.get('TeamShort') == "FRA" ||
                          team.get('TeamShort') == "ARG")
                        IconButton(
                            onPressed: () async {
                              await FirebaseMessaging.instance
                                  .subscribeToTopic(team.get('TeamShort'));
                              print("suscrito");
                            },
                            icon: Icon(Icons.add)),
                      if (team.get('TeamShort') == "MEX" ||
                          team.get('TeamShort') == "FRA" ||
                          team.get('TeamShort') == "ARG")
                        IconButton(
                            onPressed: () async {
                              await FirebaseMessaging.instance
                                  .unsubscribeFromTopic(team.get("TeamShort"));
                              print("Suscripció cancelada");
                            },
                            icon: Icon(Icons.minimize))
                    ]),
                  ),
                );
              },
            );

            //Text(snapshot.data!.docs.first.get('titlePlace'));
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
        },
      ),
    );
  }
}
