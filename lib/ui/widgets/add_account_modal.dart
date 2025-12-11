import 'package:flutter/material.dart';

class AddAccountModal extends StatelessWidget {
  const AddAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        Container(
          height: MediaQuery.of(context).size.height * 0.80,
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Image.asset("assets/images/icon_add_account.png"),
            const SizedBox(height: 32),
            // Título da aplicação
            const Text(
              "Adicionar nova conta",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Preencha os dados abaixo:",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Sobrenome',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){}, child: const Text("Cancelar")),
                ElevatedButton(onPressed: (){}, child: const Text("Adicionar"),),
              ]
            )

          ]),
        );
  }
}
