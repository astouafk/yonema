// // lib/app/data/providers/transaction_provider.dart
// import '../models/transaction_model.dart';
// import 'firebase_provider.dart';

// class TransactionProvider extends FirebaseProvider {
//  Future<void> createTransaction(TransactionModel transaction) async {
//    final newTransRef = transactions.push();
//    await newTransRef.set(transaction.toJson());
//  }

//  Future<TransactionModel?> getTransaction(String tid) async {
//    final snapshot = await transactions.child(tid).get();
//    if (snapshot.exists) {
//      return TransactionModel.fromJson(
//        Map<String, dynamic>.from(snapshot.value as Map)
//      );
//    }
//    return null;
//  }

//  Future<void> updateTransaction(String tid, TransactionModel transaction) async {
//    await transactions.child(tid).update(transaction.toJson());
//  }

//  Future<List<TransactionModel>> getUserTransactions(String userId) async {
//    final snapshot = await transactions
//      .orderByChild('exp')
//      .equalTo(userId)
//      .get();
   
//    if (snapshot.exists) {
//      final Map<dynamic, dynamic> values = snapshot.value as Map;
//      return values.entries.map((entry) {
//        final transaction = TransactionModel.fromJson(
//          Map<String, dynamic>.from(entry.value)
//        );
//        transaction.id = entry.key;
//        return transaction;
//      }).toList();
//    }
//    return [];
//  }

//  Stream<List<TransactionModel>> getUserTransactionsStream(String userId) {
//    return transactions
//      .orderByChild('exp')
//      .equalTo(userId)
//      .onValue
//      .map((event) {
//        if (event.snapshot.value != null) {
//          final Map<dynamic, dynamic> values = event.snapshot.value as Map;
//          return values.entries.map((entry) {
//            final transaction = TransactionModel.fromJson(
//              Map<String, dynamic>.from(entry.value)
//            );
//            transaction.id = entry.key;
//            return transaction;
//          }).toList();
//        }
//        return <TransactionModel>[];
//      });
//  }
// }
