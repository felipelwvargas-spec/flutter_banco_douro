// Modelo que representa uma conta no sistema.
// Contém dados básicos como identificador, nome, sobrenome, saldo e um
// campo opcional `accountType` usado para regras de negócio (por exemplo,
// cálculo de impostos).
import 'dart:convert';

/// Representa uma conta de usuário com informações essenciais.
class Account {
  /// Identificador da conta (string para facilitar serialização e IDs externos)
  String id;

  /// Primeiro nome
  String name;

  /// Sobrenome
  String lastName;

  /// Saldo atual da conta
  double balance;

  /// Tipo de conta (opcional) usado por regras como cálculo de taxas
  String? accountType;

  /// Construtor principal da classe
  Account({
    required this.id,
    required this.name,
    required this.lastName,
    required this.balance,
    required this.accountType,
  });

  /// Cria uma instância de `Account` a partir de um `Map` (p.ex., JSON decodificado)
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      balance: map['balance'] as double,
      accountType:
          (map['accountType'] != null) ? map['accountType'] as String : null,
    );
  }

  /// Converte a instância em `Map` para serialização (ex.: salvar em JSON)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lastName': lastName,
      'balance': balance,
      'accountType': accountType,
    };
  }

  /// Cria uma cópia do objeto, permitindo sobrescrever campos específicos
  Account copyWith({
    String? id,
    String? name,
    String? lastName,
    double? balance,
    String? accountType,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      balance: balance ?? this.balance,
      accountType: accountType ?? this.accountType,
    );
  }

  /// Serializa a instância para JSON (String)
  String toJson() => json.encode(toMap());

  /// Cria a instância a partir de uma string JSON
  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Representação amigável para logs/prints com quebras de linha
  @override
  String toString() {
    return '\nConta $id\n$name $lastName\nSaldo: $balance\n';
  }
 /// Comparação de igualdade baseada nos campos da conta
  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lastName == lastName &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ lastName.hashCode ^ balance.hashCode;
  }
}
