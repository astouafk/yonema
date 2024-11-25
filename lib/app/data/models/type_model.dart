// lib/app/data/models/type_model.dart
class TypeModel {
 String? id;
 String? libelle;
 String? description;
 DateTime? createdAt;
 DateTime? updatedAt;

 TypeModel({
   this.id,
   this.libelle,
   this.description,
   this.createdAt,
   this.updatedAt,
 });

 Map<String, dynamic> toJson() => {
   'id': id,
   'libelle': libelle,
   'description': description,
   'created_at': createdAt?.toIso8601String(),
   'updated_at': updatedAt?.toIso8601String(),
 };

 factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
   id: json['id'],
   libelle: json['libelle'],
   description: json['description'],
   createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
   updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
 );
}