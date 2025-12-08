// Serviço responsável por operações relacionadas a transações entre contas.
//
// Este service faz leitura e escrita de transações e também coordena a
// atualização dos saldos das contas envolvidas. Os dados de persistência
// estão armazenados em um Gist do GitHub (JSON) identificado pela `url`.
//
// Observações importantes:
// - As funções aqui são assíncronas e realizam chamadas HTTP.
// - Validações simples de existência de conta e saldo são aplicadas.
// - Impostos são calculados via `calculateTaxesByAccount` presente em
//   `helper_taxes.dart`.
import 'package:flutter_banco_douro/exceptions/transaction_exceptions.dart';
import 'package:flutter_banco_douro/helpers/helper_taxes.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_services.dart';
import 'package:flutter_banco_douro/models/transaction.dart';
import 'package:flutter_banco_douro/services/api_key.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';

class TransactionService {
  // Reuso do serviço de contas para leitura e gravação do estado das contas
  final AccountService _accountService = AccountService();

  // URL do Gist onde estão armazenadas as transações e contas.
  String url = "https://api.github.com/gists/b49d630bd597c03ed8b9b90d498e7f5a";

  /// Realiza uma transação entre duas contas identificadas por `idSender`
  /// e `idReceiver`, transferindo o valor `amount`.
  ///
  /// Passos principais:
  /// 1. Carrega todas as contas disponíveis.
  /// 2. Valida que ambos sender e receiver existem.
  /// 3. Calcula impostos aplicáveis ao remetente.
  /// 4. Verifica se o remetente tem saldo suficiente (valor + impostos).
  /// 5. Atualiza saldos localmente e persiste as contas.
  /// 6. Cria e persiste o registro da transação.
  Future<void> makeTransaction({
    required String idSender,
    required String idReceiver,
    required double amount,
  }) async {
    // Carrega todas as contas atuais
    List<Account> listAccounts = await _accountService.getAll();

    // Verifica existência do remetente
    if (listAccounts.where((acc) => acc.id == idSender).isEmpty) {
      // Retorna null em caso de erro/validação falha (poderíamos lançar uma
      // exceção ou retornar um Result/Either para tratamento mais rico)
      throw SenderNotExistException();
    }

    // Obtém o objeto da conta do remetente
    Account senderAccount = listAccounts.firstWhere(
      (acc) => acc.id == idSender,
    );

    // Verifica existência do destinatário
    if (listAccounts.where((acc) => acc.id == idReceiver).isEmpty) {
      throw ReceiverNotExistException();
    }

    // Obtém o objeto da conta do destinatário
    Account receiverAccount = listAccounts.firstWhere(
      (acc) => acc.id == idReceiver,
    );

    // Calcula impostos com base no tipo de conta e valor
    double taxes = calculateTaxesByAccount(
      sender: senderAccount,
      amount: amount,
    );

    // Validação de saldo: o remetente precisa ter saldo >= amount + taxes
    if (senderAccount.balance < amount + taxes) {
      throw InsufficientFundsException(
        cause: senderAccount,
        amount: amount,
        taxes: taxes,
      );
    }

    // Atualiza os saldos localmente (subtrai do remetente, adiciona ao receptor)
    senderAccount.balance -= (amount + taxes);
    receiverAccount.balance += amount;

    // Substitui as instâncias atualizadas na lista de contas
    listAccounts[listAccounts.indexWhere(
      (acc) => acc.id == senderAccount.id,
    )] = senderAccount;

    listAccounts[listAccounts.indexWhere(
      (acc) => acc.id == receiverAccount.id,
    )] = receiverAccount;

    // Cria o registro da transação com ID aleatório
    Transaction transaction = Transaction(
      id: (Random().nextInt(89999) + 10000).toString(),
      senderAccountId: senderAccount.id,
      receiverAccountId: receiverAccount.id,
      date: DateTime.now(),
      amount: amount,
      taxes: taxes,
    );

    // Persiste lista de contas atualizada e adiciona o registro de transação
    await _accountService.save(listAccounts);
    await addTransaction(transaction);
  }

  /// Recupera todas as transações do Gist e as converte para objetos `Transaction`.
  Future<List<Transaction>> getAll() async {
    Response response = await get(Uri.parse(url));

    // O Gist retorna um JSON cuja chave `files` contém o arquivo
    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse["files"]["transactions.json"]["content"]);

    List<Transaction> listTransactions = [];

    // Converte cada item do array JSON em Transaction
    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapTrans = dyn as Map<String, dynamic>;
      Transaction transaction = Transaction.fromMap(mapTrans);
      listTransactions.add(transaction);
    }

    return listTransactions;
  }

  /// Adiciona uma transação à lista existente e persiste.
  addTransaction(Transaction trans) async {
    List<Transaction> listTransactions = await getAll();
    listTransactions.add(trans);
    save(listTransactions);
  }

  /// Persiste a lista de transações no Gist (substitui o conteúdo do arquivo).
  save(List<Transaction> listTransactions) async {
    List<Map<String, dynamic>> listMaps = [];

    for (Transaction trans in listTransactions) {
      listMaps.add(trans.toMap());
    }

    String content = json.encode(listMaps);

    // Faz a requisição POST para atualizar o Gist (usado aqui como armazenamento)
    await post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $githubApiKey",
      },
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "transactions.json": {"content": content}
        }
      }),
    );
  }
}
