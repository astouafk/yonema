// lib/app/data/providers/type_provider.dart
import '../models/type_model.dart';
import 'firebase_provider.dart';

class TypeProvider extends FirebaseProvider {
 Future<void> createType(TypeModel type) async {
   final newTypeRef = types.push();
   await newTypeRef.set(type.toJson());
 }

 Future<TypeModel?> getType(String typeId) async {
   final snapshot = await types.child(typeId).get();
   if (snapshot.exists) {
     return TypeModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
   }
   return null;
 }

 Future<List<TypeModel>> getAllTypes() async {
   final snapshot = await types.get();
   if (snapshot.exists) {
     final Map<dynamic, dynamic> values = snapshot.value as Map;
     return values.entries.map((entry) {
       final type = TypeModel.fromJson(Map<String, dynamic>.from(entry.value));
       type.id = entry.key;
       return type;
     }).toList();
   }
   return [];
 }
}