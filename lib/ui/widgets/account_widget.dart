import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart' show Account;
import 'package:flutter_banco_douro/ui/styles/colors.dart';

/// Widget que exibe as informações de uma conta individual
class AccountWidget extends StatelessWidget {
  /// Dados da conta a ser exibida
  final Account account;
  
  const AccountWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      // Estilo visual do card da conta
      decoration: BoxDecoration(
        color: AppColor.lightOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      // Conteúdo: informações à esquerda, ícone de configurações à direita
      child: Row(
        // Não usar spaceBetween junto com Expanded; controlar espaçamento manualmente
        children: [
          // Coluna com os detalhes da conta (usa Expanded para evitar overflow em textos longos)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome completo do titular
                Text(
                  "${account.name} ${account.lastName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // ID da conta
                Text(
                  "ID: ${account.id}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Saldo formatado com 2 casas decimais
                Text(
                  "Saldo: ${account.balance.toStringAsFixed(2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Tipo de conta (com valor padrão se não definido)
                Text(
                  "Tipo: ${account.accountType ?? "Sem tipo definido."}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Botão de configurações (padding e constraints reduzidos para evitar aumento de largura)
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
