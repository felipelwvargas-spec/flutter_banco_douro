// Helper responsável pelo cálculo de impostos aplicáveis a uma transação
// com base no tipo da conta do remetente e no valor.
//
// Regras implementadas:
// - Transações com valor menor que 5000 não têm imposto (retorna 0).
// - Para tipos de conta conhecidos (AMBROSIA, CANJICA, PUDIM) aplica-se uma
//   taxa percentual específica.
// - Para tipos desconhecidos há uma taxa mínima (ex.: 0.0001 * amount).
// - Se `accountType` for nulo, retorna 0.1 (valor fixo/porcentagem dependendo
//   do contexto — atualmente retorna 0.1 que representa 10% do valor, o que
//   pode ser intencional ou um fallback; revisar se desejar comportamento
//   diferente).
import '../models/account.dart';

double calculateTaxesByAccount({
  required Account sender,
  required double amount,
}) {
  // Sem imposto para quantias pequenas (regra de negócio definida aqui)
  if (amount < 5000) return 0;

  // Se o tipo de conta estiver informado, normalizamos para maiúsculas
  // e aplicamos a taxa correspondente.
  if (sender.accountType != null) {
    final type = sender.accountType!.toUpperCase();
    if (type == "AMBROSIA") {
      // 0.5% de taxa
      return amount * 0.005;
    } else if (type == "CANJICA") {
      // 0.33% de taxa
      return amount * 0.0033;
    } else if (type == "PUDIM") {
      // 0.25% de taxa
      return amount * 0.0025;
    } else {
      // Tipo desconhecido: taxa muito baixa (0.01%)
      return amount * 0.0001; // fallback para 'brigadeiro'
    }
  } else {
    // Se não há tipo definido, retorna 0.1 (atualmente 10% do valor).
    // Atenção: este comportamento é bem agressivo; revise caso deseje outro
    // valor default (por exemplo, 0.0 ou uma pequena taxa fixa).
    return 0.1;
  }
}
