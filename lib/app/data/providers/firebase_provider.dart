// lib/app/data/providers/firebase_provider.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FirebaseProvider extends GetxService {
 final FirebaseDatabase _db = FirebaseDatabase.instance;

 DatabaseReference get users => _db.ref().child('users');
 DatabaseReference get transactions => _db.ref().child('transactions');
 DatabaseReference get roles => _db.ref().child('roles');
 DatabaseReference get types => _db.ref().child('types');

  // Pour debug
  FirebaseProvider() {
    print('=== FirebaseProvider initialisé ===');
    print('URL de la base: ${_db.ref().path}');
  }
}

