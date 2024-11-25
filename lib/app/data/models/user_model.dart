// // lib/app/data/models/user_model.dart
// class UserModel {
//   String? id;
//   String? nom;
//   String? prenom;
//   String? telephone;
//   String? email;
//   String?adresse;
//   double? solde;
//   int? roleId;

//   UserModel({
//     this.id,
//     this.nom,
//     this.prenom,
//     this.telephone,
//     this.email,
//     this.adresse,
//     this.solde,
//     this.roleId,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//     id: json['id']?.toString(),
//     nom: json['nom']?.toString(),
//     prenom: json['prenom']?.toString(),
//     telephone: json['telephone']?.toString(),
//     email: json['email']?.toString(),
//     adresse: json['adresse']?.toString(),
//     solde: json['solde']?.toDouble(),
//     roleId: json['role_id'],
//   );

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'nom': nom,
//     'prenom': prenom,
//     'telephone': telephone,
//     'email': email,
//     'solde': solde,
//     'adresse': adresse,
//     'role_id': roleId,
//   };
// }


// lib/app/data/models/user_model.dart
class UserModel {
  String? id;
  String? nom;
  String? prenom;
  String? telephone;
  String? email;
  double? solde;
  String? code;  
  double? promo;
  String? carte;
  bool? etatcarte;
  String? adresse;
  DateTime? dateNaissance;  
  int? roleId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.nom,
    this.prenom,
    this.telephone,
    this.email,
    this.solde,
    this.code,
    this.promo,
    this.carte,
    this.etatcarte = false,
    this.adresse,
    this.dateNaissance,
    this.roleId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id']?.toString(),
    nom: json['nom']?.toString(),
    prenom: json['prenom']?.toString(),
    telephone: json['telephone']?.toString(),
    email: json['email']?.toString(),
    solde: (json['solde'] is num) ? (json['solde'] as num).toDouble() : 0.0,
    code: json['code']?.toString(),
    promo: (json['promo'] is num) ? (json['promo'] as num).toDouble() : 0.0,
    carte: json['carte']?.toString(),
    etatcarte: json['etatcarte'] ?? false,
    adresse: json['adresse']?.toString(),
    dateNaissance: json['date_naissance'] != null ? DateTime.parse(json['date_naissance'].toString()) : null,
    roleId: json['role_id'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'email': email,
    'solde': solde,
    'code': code,
    'promo': promo,
    'carte': carte,
    'etatcarte': etatcarte,
    'adresse': adresse,
    'date_naissance': dateNaissance?.toIso8601String(),
    'role_id': roleId,
  };
}