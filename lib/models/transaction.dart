// Modelo que representa uma transação entre duas contas.
// Contém informações essenciais como: IDs das contas, data, valor e impostos.
import 'dart:convert';

class Transaction {
  /// Identificador único da transação (string para facilitar serialização)
  String id;

  /// ID da conta remetente
  String senderAccountId;

  /// ID da conta destinatária
  String receiverAccountId;

  /// Data/hora da transação
  DateTime date;

  /// Valor transferido
  double amount;

  /// Impostos cobrados nesta transação
  double taxes;

  Transaction({
    required this.id,
    required this.senderAccountId,
    required this.receiverAccountId,
    required this.date,
    required this.amount,
    required this.taxes,
  });

  /// Cria uma cópia do objeto permitindo sobrescrever campos desejados.
  Transaction copyWith({
    String? id,
    String? senderAccountId,
    String? receiverAccountId,
    DateTime? date,
    double? amount,
    double? taxes,
  }) {
    return Transaction(
      id: id ?? this.id,
      senderAccountId: senderAccountId ?? this.senderAccountId,
      receiverAccountId: receiverAccountId ?? this.receiverAccountId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      taxes: taxes ?? this.taxes,
    );
  }

  /// Converte a instância para um Map para serialização.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderAccountId': senderAccountId,
      'receiverAccountId': receiverAccountId,
      // Armazenamos a data como millisecondsSinceEpoch para interoperabilidade
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'taxes': taxes,
    };
  }

  /// Cria uma instância a partir de um Map (geralmente vindo de um JSON).
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      senderAccountId: map['senderAccountId'] as String,
      receiverAccountId: map['receiverAccountId'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as double,
      taxes: map['taxes'] as double,
    );
  }

  /// Serializa para JSON (String)
  String toJson() => json.encode(toMap());

  /// Cria a instância a partir de uma string JSON
  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, senderAccountId: $senderAccountId, receiverAccountId: $receiverAccountId, date: $date, amount: $amount, taxes: $taxes)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderAccountId == senderAccountId &&
        other.receiverAccountId == receiverAccountId &&
        other.date == date &&
        other.amount == amount &&
        other.taxes == taxes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderAccountId.hashCode ^
        receiverAccountId.hashCode ^
        date.hashCode ^
        amount.hashCode ^
        taxes.hashCode;
  }
}
