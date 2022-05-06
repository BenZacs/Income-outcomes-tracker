import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  Transaction({
    required this.type,
    required this.product,
    required this.amount,
    required this.at,
  });

  Transaction.fromJson(Map<String, Object?> json)
      : this(
          type: json['type']! as String,
          product: json['product']! as String,
          at: json['at']! as Timestamp,
          amount: json['amount']! as num,
        );

  final String type;
  final String product;
  final num amount;
  final Timestamp at;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'product': product,
      'at': at,
      'amount': amount,
    };
  }
}
