import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/models/mxplayers_model.dart';

class MxPlayersFirebase {
  late FirebaseFirestore _firestore;
  CollectionReference? _mxplayersCollection;

  MxPlayersFirebase() {
    _firestore = FirebaseFirestore.instance;
    _mxplayersCollection = _firestore.collection('MxPlayers');
  }

  Future<void> insPlace(MxPlayersModel objPlayers) {
    return _mxplayersCollection!.add(objPlayers.toMap());
  }

  Future<void> delPlaces(String iPlayer) {
    return _mxplayersCollection!.doc(iPlayer).delete();
  }

  Future<void> updPlaces(MxPlayersModel objPlayers, String iPlayer) {
    return _mxplayersCollection!.doc(iPlayer).update(objPlayers.toMap());
  }

  Stream<QuerySnapshot> getAllMxPlayers() {
    return _mxplayersCollection!.snapshots();
  }
}
