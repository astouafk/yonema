// lib/app/data/seeds/database_seed.dart
import 'package:firebase_database/firebase_database.dart';

class DatabaseSeed {
 final FirebaseDatabase _db = FirebaseDatabase.instance;

 // Vérifier si la base a déjà été initialisée
 Future<bool> isDatabaseSeeded() async {
   final snapshot = await _db.ref().child('database_seeded').get();
   return snapshot.exists && snapshot.value == true;
 }

 // Marquer la base comme initialisée
 Future<void> markDatabaseAsSeeded() async {
   await _db.ref().child('database_seeded').set(true);
 }

 Future<void> cleanDatabase() async {
   try {
     await _db.ref().remove();
     print('Database cleaned successfully');
   } catch (e) {
     print('Error cleaning database: $e');
   }
 }

 Future<void> initializeDatabase() async {
   if (await isDatabaseSeeded()) {
     print('Database already seeded');
     return;
   }

   try {
     print('Starting database seeding...');
     await cleanDatabase(); // Nettoyer d'abord
     await seedRoles();
    //  await seedTypes();
     await seedUsers();
     await markDatabaseAsSeeded();
     print('Database seeding completed successfully');
   } catch (e) {
     print('Error seeding database: $e');
   }
 }

 Future<void> seedRoles() async {
    print('Seeding roles...');
    final roles = [
      {
        'id': 1,
        'name': 'admin',
        'description': 'Administrateur du système',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
      {
        'id': 2,
        'name': 'client',
        'description': 'Utilisateur standard',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
      {
        'id': 3,
        'name': 'agent',
        'description': 'Agent distributeur',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      }
    ];

    for (var role in roles) {
      await _db.ref().child('roles').child(role['id'].toString()).set(role);
    }
    print('Roles seeded successfully');
  }

//  Future<void> seedTypes() async {
//    print('Seeding transaction types...');
//    final types = [
//      {
//        'libelle': 'depot',
//        'description': 'Dépôt d\'argent',
//        'created_at': DateTime.now().toIso8601String(),
//        'updated_at': DateTime.now().toIso8601String()
//      },
//      {
//        'libelle': 'retrait',
//        'description': 'Retrait d\'argent',
//        'created_at': DateTime.now().toIso8601String(),
//        'updated_at': DateTime.now().toIso8601String()
//      },
//      {
//        'libelle': 'transfert',
//        'description': 'Transfert d\'argent',
//        'created_at': DateTime.now().toIso8601String(),
//        'updated_at': DateTime.now().toIso8601String()
//      }
//    ];

//    for (var type in types) {
//      await _db.ref().child('types').push().set(type);
//    }
//    print('Transaction types seeded successfully');
//  }

  Future<void> seedUsers() async {
    print('Seeding users...');
    final users = [
      {
        'id': 1,
        'nom': 'Diallo',
        'prenom': 'Mamadou',
        'telephone': '776543210',
        'photo': 'admin.jpg',
        'email': 'admin@yonemaget.com',
        'solde': 1000000.00,
        'code': '123456',
        'promo': 0.00,
        'carte': 'ADMIN123',
        'etatcarte': true,
        'adresse': 'Dakar, Sénégal',
        'date_naissance': '1990-01-01',
        'secret': 'admin_secret',
        'role_id': 1, // admin
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
      {
        'id': 2,
        'nom': 'Ndiaye',
        'prenom': 'Fatou',
        'telephone': '701234567',
        'photo': 'client.jpg',
        'email': 'client@yonemaget.com',
        'solde': 50000.00,
        'code': '654321',
        'promo': 5.00,
        'carte': 'CLIENT123',
        'etatcarte': true,
        'adresse': 'Thiès, Sénégal',
        'date_naissance': '1995-01-01',
        'secret': 'client_secret',
        'role_id': 2, // client
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
      {
        'id': 3,
        'nom': 'Sow',
        'prenom': 'Ibrahima',
        'telephone': '759876543',
        'photo': 'agent.jpg',
        'email': 'agent@yonemaget.com',
        'solde': 500000.00,
        'code': '789012',
        'promo': 0.00,
        'carte': 'AGENT123',
        'etatcarte': true,
        'adresse': 'Saint-Louis, Sénégal',
        'date_naissance': '1992-01-01',
        'secret': 'agent_secret',
        'role_id': 3, // agent
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
      {
        'id': 4,
        'nom': 'Fall',
        'prenom': 'Aminata',
        'telephone': '782345678',
        'photo': 'client.jpg',
        'email': 'client2@yonemaget.com',
        'solde': 75000.00,
        'code': '345678',
        'promo': 5.00,
        'carte': 'CLIENT456',
        'etatcarte': true,
        'adresse': 'Rufisque, Sénégal',
        'date_naissance': '1993-05-15',
        'secret': 'client_secret2',
        'role_id': 2, // client
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
      {
        'id': 5,
        'nom': 'Gueye',
        'prenom': 'Ousmane',
        'telephone': '765432109',
        'photo': 'agent.jpg',
        'email': 'agent2@yonemaget.com',
        'solde': 450000.00,
        'code': '901234',
        'promo': 0.00,
        'carte': 'AGENT456',
        'etatcarte': true,
        'adresse': 'Touba, Sénégal',
        'date_naissance': '1991-08-20',
        'secret': 'agent_secret2',
        'role_id': 3, // agent
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      }
    ];

    for (var user in users) {
      await _db.ref().child('users').child(user['id'].toString()).set(user);
    }
    print('Users seeded successfully');
  }
 // Méthode pour reseed la base de données (utile pendant le développement)
 Future<void> reseedDatabase() async {
   print('Reseeding database...');
   await cleanDatabase();
   await initializeDatabase();
   print('Database reseeded successfully');
 }
}