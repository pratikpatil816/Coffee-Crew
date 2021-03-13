import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_crew/models/coffee.dart';
import 'package:coffee_crew/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference coffeeCollection = Firestore.instance.collection('coffee');

  Future updateUserData(String sugars, String name, int strength)async{
    return await coffeeCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength
    });
  }

  // coffee list from snapshot
  List<Coffee> _coffeeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Coffee(
        name: doc.data['name'] ?? '',
        sugars: doc.data['sugars'] ?? '0',
        strength: doc.data['strength'] ?? 0
      );
    }).toList();
  }
 
  // userData from snapshots
  UserData _userDataFromSnapshots(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }
  
  // get coffee stream
  Stream<List<Coffee>> get coffee {
    return coffeeCollection.snapshots()
      .map(_coffeeListFromSnapshot);
  }
  
  //get user data
  Stream<UserData> get userData {
    return coffeeCollection.document(uid).snapshots()
      .map(_userDataFromSnapshots);
  }

}