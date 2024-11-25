// lib/app/data/providers/role_provider.dart
import '../models/role_model.dart';
import 'firebase_provider.dart';

class RoleProvider extends FirebaseProvider {
 Future<void> createRole(RoleModel role) async {
   final newRoleRef = roles.push();
   await newRoleRef.set(role.toJson());
 }

 Future<RoleModel?> getRole(String roleId) async {
   final snapshot = await roles.child(roleId).get();
   if (snapshot.exists) {
     return RoleModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
   }
   return null;
 }

 Future<List<RoleModel>> getAllRoles() async {
   final snapshot = await roles.get();
   if (snapshot.exists) {
     final Map<dynamic, dynamic> values = snapshot.value as Map;
     return values.entries.map((entry) {
       final role = RoleModel.fromJson(Map<String, dynamic>.from(entry.value));
       role.id = entry.key;
       return role;
     }).toList();
   }
   return [];
 }
}