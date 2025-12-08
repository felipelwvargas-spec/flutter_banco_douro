import 'package:flutter_banco_douro/models/account.dart';

class SenderNotExistException implements Exception {
  String message;
  SenderNotExistException({
    this.message = "Conta remetente não encontrada.",
  });
}

class ReceiverNotExistException implements Exception {
  String message;
  ReceiverNotExistException({
    this.message = "Conta destinatária não encontrada.",
  });
}

class InsufficientFundsException implements Exception {
  String message; // mensagem amigavel
  Account cause; // conta que causou o erro
  double amount; // valor da tentativa de transferência
  double taxes; // valor dos impostos calculados
  InsufficientFundsException({
    this.message = "Saldo insuficiente para completar a transação.",
    required this.cause,
    required this.amount,
    required this.taxes,  
    });
}