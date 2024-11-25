// lib/app/data/models/role_model.dart
class RoleModel {
 String? id;
 String? name;
 String? description;
 DateTime? createdAt;
 DateTime? updatedAt;

 RoleModel({
   this.id,
   this.name,
   this.description,
   this.createdAt,
   this.updatedAt,
 });

 Map<String, dynamic> toJson() => {
   'id': id,
   'name': name,
   'description': description,
   'created_at': createdAt?.toIso8601String(),
   'updated_at': updatedAt?.toIso8601String(),
 };

 factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
   id: json['id'],
   name: json['name'],
   description: json['description'],
   createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
   updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
 );
}