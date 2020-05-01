import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  Future updateUserData(String sugar, String name, int strength) async{
    await brewCollection.document(uid).setData({
      'sugars': sugar,
      'name': name,
      'strength': strength
      }
    );
  }

  List<Brew> _brewListFromFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugar: doc.data['sugars'] ?? '0',
      );
    }).toList();
  }

  //UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  //get brew stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

}