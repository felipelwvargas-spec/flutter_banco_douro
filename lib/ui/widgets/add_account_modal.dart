import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_services.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:uuid/uuid.dart';

/// Modal que contém o formulário para adicionar uma nova conta.
///
/// Exibe campos para nome e sobrenome e botões para confirmar ou
/// cancelar a operação.
class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  String _accountType = "AMBROSIA";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();


  /// Constrói o layout do modal com campos de entrada e botões.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        top: 32,
        left: 32,
        right: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Image.asset("assets/images/icon_add_account.png"),
          ),
          const SizedBox(height: 32),
          // Título do modal
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
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(color: Colors.blueGrey),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Sobrenome',
              labelStyle: TextStyle(color: Colors.blueGrey),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tipo de conta:",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _accountType,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: "AMBROSIA", child: Text("Ambrosia")),
              DropdownMenuItem(value: "CANJICA", child: Text("Canjica")),
              DropdownMenuItem(value: "PUDIM", child: Text("Pudim")),
              DropdownMenuItem(value: "BRIGADEIRO", child: Text("Brigadeiro")),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _accountType = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 10),

          Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      onButtonCancelClicked();
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColor.orange,
                      ),
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black),
                    ))),
            const SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                onButtonSendClicked();
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  AppColor.orange,
                ),
              ),
              child: const Text(
                "Adicionar",
                style: TextStyle(color: Colors.black),
              ),
            )),
          ])
        ]),
      ),
    );
  }
  onButtonCancelClicked() {
    Navigator.pop(context);
  }
  onButtonSendClicked() {
    // Lógica para adicionar a conta
    String name = _nameController.text;
    String lastName = _lastNameController.text;

    Account account = Account(
      id: const Uuid().v1(), 
      name: name, 
      lastName: lastName, 
      balance: 0, 
      accountType: _accountType,
      );

    AccountService().addAccount(account);
  }

}
