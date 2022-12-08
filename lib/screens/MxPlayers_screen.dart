import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../firebase/mxplayers_firebase.dart';

class MxPlayersScreen extends StatefulWidget {
  const MxPlayersScreen({Key? key}) : super(key: key);

  @override
  State<MxPlayersScreen> createState() => _MxPlayersScreen();
}

class _MxPlayersScreen extends State<MxPlayersScreen> {
  MxPlayersFirebase? _mxplayersCollection;
  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mxplayersCollection = MxPlayersFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores de México '),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: StreamBuilder(
        stream: _mxplayersCollection!.getAllMxPlayers(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var mxplayer = snapshot.data!.docs[index];
                
                return Container(
                  width: 650.0,
                  height: 800.0,
                  child: PhotoViewGallery.builder(
                    itemCount: snapshot.data!.docs.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(mxplayer.get('ImgPlayer')),
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
