import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/models/teams_model.dart';

class TeamsFirebase{
  late FirebaseFirestore _firestore;
  CollectionReference? _teamsCollection;

  TeamsFirebase(){
    _firestore = FirebaseFirestore.instance;
    _teamsCollection = _firestore.collection('Teams');
  }

  Future<void> insPlace(TeamsModel objTeams){
    return _teamsCollection!.add(objTeams.toMap());
  }

  Future<void> delPlaces(String idTeams){
    return _teamsCollection!.doc(idTeams).delete();
  }

  Future<void> updPlaces(TeamsModel objTeams, String idTeams){
    return _teamsCollection!.doc(idTeams).update(objTeams.toMap());
  }

  Stream<QuerySnapshot> getAllTeams(){
    return _teamsCollection!.snapshots();
  }
}