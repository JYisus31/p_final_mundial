import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/models/frplayers_model.dart';

class FrPlayersFirebase {
  late FirebaseFirestore _firestore;
  CollectionReference? _frplayersCollection;

  FrPlayersFirebase() {
    _firestore = FirebaseFirestore.instance;
    _frplayersCollection = _firestore.collection('FrPlayers');
  }

  Future<void> insPlace(FrPlayersModel objPlayers) {
    return _frplayersCollection!.add(objPlayers.toMap());
  }

  Future<void> delPlaces(String iPlayer) {
    return _frplayersCollection!.doc(iPlayer).delete();
  }

  Future<void> updPlaces(FrPlayersModel objPlayers, String iPlayer) {
    return _frplayersCollection!.doc(iPlayer).update(objPlayers.toMap());
  }

  Stream<QuerySnapshot> getAllFrPlayers() {
    return _frplayersCollection!.snapshots();
  }
}
