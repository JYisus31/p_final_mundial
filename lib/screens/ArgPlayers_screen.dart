import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../firebase/argplayers_firebase.dart';


class ArgPlayersScreen extends StatefulWidget {
  const ArgPlayersScreen({Key? key}) : super(key: key);

  @override
  State<ArgPlayersScreen> createState() => _ArgPlayersScreen();
}

class _ArgPlayersScreen extends State<ArgPlayersScreen> {
  ArgPlayersFirebase? _argplayersCollection;
  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _argplayersCollection = ArgPlayersFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores de Argentina '),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: StreamBuilder(
        stream: _argplayersCollection!.getAllArgPlayers(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var argplayer = snapshot.data!.docs[index];
                
                return Container(
                  width: 650.0,
                  height: 800.0,
                  child: PhotoViewGallery.builder(
                    itemCount: snapshot.data!.docs.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(argplayer.get('ImgPlayer')),
                        initialScale: PhotoViewComputedScale.contained * 1.0,
                        //minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    },
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(),
                    enableRotation: true,
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
