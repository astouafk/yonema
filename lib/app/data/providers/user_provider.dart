// // lib/app/data/providers/user_provider.dart
// import 'package:firebase_database/firebase_database.dart';
// import '../models/user_model.dart';
// import 'firebase_provider.dart';

// class UserProvider extends FirebaseProvider {
//  Future<void> createUser(UserModel user) async {
//    final newUserRef = users.push();
//    await newUserRef.set(user.toJson());
//  }

//    Future<UserModel?> getUser(String uid) async {
//     try {
//       final snapshot = await users.child(uid).get();
//       if (snapshot.exists && snapshot.value != null) {
//         final userMap = Map<String, dynamic>.from(snapshot.value as Map);
//         final user = UserModel.fromJson(userMap);
//         user.id = uid;
//         return user;
//       }
//     } catch (e) {
//       print('Erreur dans getUser: $e');
//     }
//     return null;
//   }
  
//  Future<void> updateUser(String uid, UserModel user) async {
//    await users.child(uid).update(user.toJson());
//  }

//  Future<void> deleteUser(String uid) async {
//    await users.child(uid).remove();
//  }

//  Stream<UserModel> getUserStream(String uid) {
//    return users.child(uid).onValue.map((event) {
//      return UserModel.fromJson(
//        Map<String, dynamic>.from(event.snapshot.value as Map)
//      );
//    });
//  }

//   Future<List<UserModel>> getAllUsers() async {
//     try {
//       final snapshot = await users.get();
//       print('Raw Firebase data: ${snapshot.value}'); // Debug print

//       if (snapshot.exists && snapshot.value != null) {
//         List<UserModel> usersList = [];
        
//         // Gérer la nouvelle structure où les IDs sont les clés
//         final data = snapshot.value as Map;
//         data.forEach((key, value) {
//           try {
//             if (value is Map) {
//               // Convertir la Map en UserModel
//               final userMap = Map<String, dynamic>.from(value as Map);
//               final user = UserModel.fromJson(userMap);
//               // Assurez-vous que l'ID est défini
//               user.id = key.toString();
//               usersList.add(user);
//               print('Utilisateur ajouté: ${user.telephone}'); // Debug print
//             }
//           } catch (e) {
//             print('Erreur lors de la conversion d\'un utilisateur: $e');
//           }
//         });
        
//         return usersList;
//       }
//       return [];
//     } catch (e) {
//       print('Erreur dans getAllUsers: $e');
//       return [];
//     }
//   }
// }



// lib/app/data/providers/user_provider.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import 'firebase_provider.dart';

class UserProvider extends FirebaseProvider {
  Future<List<UserModel>> getAllUsers() async {
    try {
      print('=== Début getAllUsers ===');
      
      // 1. Vérifier la référence
      print('Chemin de la référence: ${users.path}');
      
      // 2. Obtenir le snapshot
      final snapshot = await users.get();
      print('Snapshot existe: ${snapshot.exists}');
      
      // 3. Vérifier la valeur brute
      if (snapshot.exists) {
        print('Valeur brute du snapshot: ${snapshot.value}');
      }

      if (snapshot.exists && snapshot.value != null) {
        List<UserModel> usersList = [];
        final data = snapshot.value as Map;
        print('Type de données reçues: ${data.runtimeType}');
        
        data.forEach((key, value) {
          print('Traitement de l\'utilisateur $key');
          print('Données de l\'utilisateur: $value');
          
          try {
            if (value != null) {
              final userData = Map<String, dynamic>.from(value as Map);
              final user = UserModel.fromJson(userData);
              user.id = key.toString();
              usersList.add(user);
              print('Utilisateur ajouté avec succès - ID: ${user.id}, Tél: ${user.telephone}');
            }
          } catch (e) {
            print('Erreur lors de la conversion de l\'utilisateur $key: $e');
          }
        });
        
        print('Nombre total d\'utilisateurs trouvés: ${usersList.length}');
        return usersList;
      }
      
      print('Aucune donnée trouvée');
      return [];
    } catch (e) {
      print('Erreur dans getAllUsers: $e');
      print('StackTrace: ${e.toString()}');
      return [];
    }
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    try {
      print('=== Recherche utilisateur par téléphone: $phone ===');
      
      // Vérifier d'abord tous les utilisateurs (pour debug)
      final snapshot = await users.get();
      print('Données brutes de la base: ${snapshot.value}');
      
      final query = users.orderByChild('telephone').equalTo(phone);
      final querySnapshot = await query.get();
      print('Résultat de la requête: ${querySnapshot.value}');

      if (querySnapshot.exists && querySnapshot.value != null) {
        final data = querySnapshot.value as Map;
        final firstEntry = data.entries.first;
        
        print('Utilisateur trouvé - clé: ${firstEntry.key}');
        
        final userData = Map<String, dynamic>.from(firstEntry.value);
        final user = UserModel.fromJson(userData);
        user.id = firstEntry.key.toString();
        return user;
      }
      
      print('Aucun utilisateur trouvé avec ce numéro');
    } catch (e) {
      print('Erreur dans getUserByPhone: $e');
      print('StackTrace: ${e.toString()}');
    }
    return null;
  }
  Future<UserModel?> getUser(String uid) async {
    try {
      final snapshot = await users.child(uid).get();
      if (snapshot.exists && snapshot.value != null) {
        final userMap = Map<String, dynamic>.from(snapshot.value as Map);
        final user = UserModel.fromJson(userMap);
        user.id = uid;
        return user;
      }
    } catch (e) {
      print('Erreur dans getUser: $e');
    }
    return null;
  }
  
}