// Serviço responsável por ler e gravar as contas do sistema.
//
// Os dados são persistidos em um Gist do GitHub (JSON). Este serviço oferece
// métodos para ler todas as contas (`getAll`), adicionar uma nova conta
// (`addAccount`) e salvar a lista completa (`save`). Também expõe um
// `Stream<String>` para emitir logs simples sobre operações realizadas,
// útil para debug ou UI reativa.
import 'dart:async';
import '../models/account.dart';
import 'package:flutter_banco_douro/services/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AccountService {
  // Controlador de stream usado para emitir mensagens de status/log.
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  // URL do Gist que armazena os dados das contas (arquivo `accounts.json`).
  String url = "https://api.github.com/gists/b49d630bd597c03ed8b9b90d498e7f5a";

  /// Recupera todas as contas persistidas no Gist.
  ///
  /// - Faz uma requisição HTTP GET para a URL configurada.
  /// - Decodifica o JSON retornado e converte os itens em `Account`.
  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    // Emite uma mensagem simples informando que houve a requisição
    _streamController.add("${DateTime.now()} | Requisição de leitura.");

    // O Gist contém um objeto `files` e o conteúdo de `accounts.json` é uma
    // string JSON — por isso são dois `decode` seguidos.
    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse["files"]["accounts.json"]["content"]);

    List<Account> listAccounts = [];

    // Converte cada elemento do array em instância de Account
    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  /// Adiciona uma nova conta à lista existente e persiste as mudanças.
  ///
  /// Este método carrega as contas atuais, acrescenta a nova conta e chama
  /// `save` para persistir a lista atualizada. Emite logs via stream.
  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);
    save(listAccounts, accountName: account.name);
  }

  /// Persiste a lista completa de contas no Gist.
  ///
  /// - Converte cada `Account` em `Map` e serializa para JSON.
  /// - Faz uma requisição POST com o novo conteúdo do arquivo `accounts.json`.
  /// - Emite mensagem de sucesso ou falha na `streamInfos` para monitoramento.
  save(List<Account> listAccounts, {String accountName = ""}) async {
    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $githubApiKey"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {
            "content": content,
          }
        }
      }),
    );

    // Checa se o status code começa com '2' para considerar sucesso
    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Requisição adição bem sucedida ($accountName).");
    } else {
      _streamController
          .add("${DateTime.now()} | Requisição falhou ($accountName).");
    }
  }
}
