import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/ui/home_screen.dart';
import 'package:flutter_banco_douro/ui/login_screen.dart';

/// Ponto de entrada da aplicação
void main() {
  runApp(const BancoDouroApp());
}

/// Widget raiz da aplicação - configura rotas e tema
class BancoDouroApp extends StatelessWidget {
  const BancoDouroApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define as rotas disponíveis na aplicação
      routes: {
        'login': (context) => const LoginScreen(),
        'home': (context) => const HomeScreen(),
      },
      // Define a rota inicial como a tela de login
      initialRoute: 'login',
    );
  }
}