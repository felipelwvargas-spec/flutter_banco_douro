import 'package:flutter/material.dart';

/// Tela de login do aplicativo
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usa Stack para sobrepor vários widgets (banner, estrelas, formulário)
      body: Stack(
        children: [
          // Imagem de fundo (banner)
          Image.asset("assets/images/banner.png"),
          // Estrelas decorativas posicionadas no canto inferior esquerdo
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/images/stars.png"),
          ),
          // Padding com formulário de login
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Espaço superior
                const SizedBox(height: 128),
                // Logo do aplicativo
                Image.asset(
                  "assets/images/logo.png",
                  width: 120,
                ),
                // Coluna com os elementos do formulário
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    // Título da aplicação
                    const Text(
                      "Sistema de Gestão de Contas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Campo de entrada para e-mail
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("E-mail"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de entrada para senha (oculta o texto)
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text("Senha"),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Botão de login que navega para a tela de home
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "home");
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xFFFFA902),
                        ),
                      ),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}