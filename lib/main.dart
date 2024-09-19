import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MeuApp(),
  ));
}

class MeuApp extends StatefulWidget {
  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Afazeres'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tarefas[index].descricao),
                  leading: Checkbox(
                    value: _tarefas[index].status,
                    onChanged: (novoValor) {
                      setState(() {
                        _tarefas[index].status = novoValor ?? false;
                      });
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editarTarefa(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _excluirTarefa(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controlador,
                    decoration: const InputDecoration(
                      hintText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith<Size>(
                      (Set<MaterialState> states) {
                        return const Size(200, 60); // Tamanho do botão
                      },
                    ),
                  ),
                  child: const Text('Adicionar Tarefa'),
                  onPressed: () {
                    if (controlador.text.isEmpty) {
                      return;
                    }
                    setState(() {
                      _tarefas.add(
                        Tarefa(
                          descricao: controlador.text,
                          status: false,
                        ),
                      );
                      controlador.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editarTarefa(int index) {
    controlador.text = _tarefas[index].descricao;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            controller: controlador,
            decoration: const InputDecoration(
              hintText: 'Nova descrição',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarefas[index].descricao = controlador.text;
                });
                controlador.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                controlador.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
