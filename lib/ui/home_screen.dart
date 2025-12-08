import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_services.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:flutter_banco_douro/ui/widgets/account_widget.dart';

/// Tela principal que lista todas as contas do usuário.
///
/// Esta tela é um `StatefulWidget` porque mantém um `Future<List<Account>>`
/// em `_futureGetAll` para evitar refazer a requisição desnecessariamente a
/// cada rebuild. Também fornece suporte a pull-to-refresh via
/// `RefreshIndicator` — o método `refreshGetAll` atualiza `_futureGetAll`
/// dentro de um `setState` para forçar o `FutureBuilder` a recarregar os
/// dados.
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Cache do Future usado pelo FutureBuilder. Inicializado na criação do
  // estado para que a requisição seja feita apenas quando necessário.
  Future<List<Account>> _futureGetAll = AccountService().getAll();

  // Função chamada pelo RefreshIndicator. Atualiza o Future e chama
  // setState para que o FutureBuilder reconstrua e recarregue os dados.
  Future<void> refreshGetAll() async {
    setState(() {
      _futureGetAll = AccountService().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.lightGray,
        title: const Text('Sistema de gestão de Contas'),
        // Ações disponíveis na AppBar
        actions: [
          // Botão de logout
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação ao pressionar o botão de adicionar conta
        },
        backgroundColor: AppColor.orange,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // FutureBuilder para carregar contas de forma assíncrona
        child: RefreshIndicator(
          onRefresh: refreshGetAll,
          child: FutureBuilder(
            future: _futureGetAll,
            builder: (context, snapshot) {
              // Verifica o estado da conexão (carregamento, conclusão, etc.)
              switch (snapshot.connectionState) {
                // Estado: nenhuma requisição foi feita
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                // Estado: aguardando resposta da API
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                // Estado: requisição em progresso
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                // Estado: requisição concluída
                case ConnectionState.done:
                  // Se não houver dados ou a lista estiver vazia
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma conta encontrada."),
                    );
                  } else {
                    // Constrói uma lista de cards das contas
                    List<Account> listAccounts = snapshot.data!;
                    return ListView.builder(
                      itemCount: listAccounts.length,
                      itemBuilder: (context, index) {
                        Account account = listAccounts[index];
                        return AccountWidget(account: account);
                      },
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
