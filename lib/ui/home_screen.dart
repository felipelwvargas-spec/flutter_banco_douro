import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_services.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:flutter_banco_douro/ui/widgets/account_widget.dart';

/// Tela principal que lista todas as contas do usuário
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Account>> refreshGetAll() async {
    return AccountService().getAll();
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        // FutureBuilder para carregar contas de forma assíncrona
        child: RefreshIndicator(
          onRefresh: refreshGetAll,
          child: FutureBuilder(
            future: AccountService().getAll(),
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
