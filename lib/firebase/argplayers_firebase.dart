import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/models/argplayers_model.dart';

class ArgPlayersFirebase {
  late FirebaseFirestore _firestore;
  CollectionReference? _argplayersCollection;

  ArgPlayersFirebase() {
    _firestore = FirebaseFirestore.instance;
    _argplayersCollection = _firestore.collection('ArgPlayers');
  }

  Future<void> insPlace(ArgPlayersModel objPlayers) {
    return _argplayersCollection!.add(objPlayers.toMap());
  }

  Future<void> delPlaces(String iPlayer) {
    return _argplayersCollection!.doc(iPlayer).delete();
  }

  Future<void> updPlaces(ArgPlayersModel objPlayers, String iPlayer) {
    return _argplayersCollection!.doc(iPlayer).update(objPlayers.toMap());
  }

  Stream<QuerySnapshot> getAllArgPlayers() {
    return _argplayersCollection!.snapshots();
  }
}
