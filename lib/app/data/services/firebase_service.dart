// lib/app/data/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart'; // Ajout de cet import pour PlatformException
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );


  // Connexion par téléphone
   Future<UserModel?> loginWithPhone(String phone, String pin) async {
    try {
      print('Tentative de connexion: $phone');
      final snapshot = await _db.child('users').get();
      
      if (!snapshot.exists) return null;

      final data = snapshot.value as List<dynamic>;
      
      for (var i = 1; i < data.length; i++) {
        if (data[i] != null) {
          final userData = Map<String, dynamic>.from(data[i]);
          if (userData['telephone'] == phone && userData['code'] == pin) {
            print('Utilisateur trouvé: ${userData['nom']}');
            final user = UserModel.fromJson(userData);
            user.id = i.toString();
            return user;
          }
        }
      }
      return null;
    } catch (e) {
      print('Erreur connexion: $e');
      return null;
    }
  }

  // Connexion avec Google
     Future<UserModel?> signInWithGoogle() async {
    try {
      // Déconnexion préalable pour éviter les problèmes de cache
      await _googleSignIn.signOut();
      await _auth.signOut();

      print('Début de la connexion Google...');
      
      // Tentative de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Sélection du compte Google annulée');
        return null;
      }

      print('Compte Google sélectionné: ${googleUser.email}');

      // Authentification
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase Auth
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        print('Recherche de l\'utilisateur dans la base...');
        
        final snapshot = await _db.child('users').get();
        if (!snapshot.exists) return null;

        final data = snapshot.value as List<dynamic>;
        
        for (var i = 1; i < data.length; i++) {
          if (data[i] != null) {
            final userData = Map<String, dynamic>.from(data[i]);
            if (userData['email']?.toString().toLowerCase() == user.email?.toLowerCase()) {
              final userModel = UserModel.fromJson(userData);
              userModel.id = i.toString();
              return userModel;
            }
          }
        }
        
        print('Email non trouvé dans la base: ${user.email}');
      }
      
      return null;
    } catch (e) {
      print('Erreur détaillée de connexion Google: $e');
      if (e is PlatformException) {
        print('Code d\'erreur: ${e.code}');
        print('Message: ${e.message}');
        print('Détails: ${e.details}');
      }
      return null;
    }
  }

   // Ajout de la méthode de connexion Facebook
 Future<UserModel?> signInWithFacebook() async {
   try {
    print('Début de la connexion Facebook...');
    
    // Déconnexion préalable
    await FacebookAuth.instance.logOut();
    
    // Connexion avec plus d'options
   final LoginResult result = await FacebookAuth.instance.login(
  permissions: ['public_profile', 'email'],
  loginBehavior: LoginBehavior.nativeWithFallback, // Changed from dialogOnly
);
    
    print('Status initial: ${result.status}');
    print('Message: ${result.message}');
    print('Access Token: ${result.accessToken?.token ?? "Aucun token"}');

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture",
      );
      print('Données utilisateur récupérées: $userData');

      final facebookEmail = userData['email'];
      print('Email Facebook: $facebookEmail');

      // Vérification dans la base de données
      final snapshot = await _db.child('users').get();
      
      if (snapshot.exists) {
        final data = snapshot.value as List<dynamic>;
        
        for (var i = 1; i < data.length; i++) {
          if (data[i] != null) {
            final dbUser = Map<String, dynamic>.from(data[i]);
            print('Comparaison avec: ${dbUser['email']}');
            
            if (dbUser['email']?.toString().toLowerCase() == facebookEmail?.toLowerCase()) {
              print('Match trouvé!');
              final userModel = UserModel.fromJson(dbUser);
              userModel.id = i.toString();
              return userModel;
            }
          }
        }
      }
    } else if (result.status == LoginStatus.cancelled) {
      print('Connexion annulée par Facebook SDK');
    } else {
      print('Erreur de connexion: ${result.status}');
    }
    
    return null;
  } catch (e) {
    print('Erreur détaillée: $e');
    return null;
  }
}

}