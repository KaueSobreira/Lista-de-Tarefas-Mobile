import 'package:flutter/material.dart';

void main() {
  runApp(TaskApp());
}

// Classe responsavel por implementar a abstracao do MaterialAPP
class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TaskListPage());  
  }
}

// Classe responsavel implementar a representação da Pagina dinamica de lista de tarefas
class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

// classe responsavel implementar o gerenciamento do Estado da TasklistPage
class _TaskListPageState extends State<TaskListPage> {
  final List<TaskModel> tasks = [
    TaskModel(title: "Busca o Cafézin"),
    TaskModel(title: "Ir para Academia"),
    TaskModel(title: "Limpa a Casa"),
  ];
  

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: taskAppBar(),
      floatingActionButton: taskAppFloatingActionButton(),
      body: taskAppBody(),
    );

  // MNetodo para criar o appBar da Pagina de Lista de Tarefas
  AppBar taskAppBar(){
    return AppBar(
        title: Center(child: Text("Lista de Tarefas"),
        ),
      );
  }

  // Segunda opção de fazer a função
  // AppBar taskAppBar() => AppBar(title: Center(child: Text("Lista de Tarefas")));

  // MNetodo para criar o Botão da Pagina de Lista de Tarefas
  FloatingActionButton taskAppFloatingActionButton() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {}
        );
  }

  // Primeira Forma de Escrever
  // Widget taskAppBody() {
  //   return Column(
  //       children: [
  //         // Dashboard
  //         // Lista de Tarefas
  //       ],
  //     );
  // }

  // MNetodo para criar o Body para Listar de Tarefas
  // Segunda Forma de Escrever
  Widget taskAppBody() => Column(
        children: [
          // Dashboard (taskAppDashBoard())

          // Lista de Tarefas
          Expanded(child: 
              ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final TaskModel task = tasks[index]; 
                  return ListTile(
                    leading: listTileLeadingWidget(task),
                    trailing: listItemTrailingWidget(index),
                    title: Text(task.title));
                },
              ),
            ),
        ],
      );

  IconButton listItemTrailingWidget(int index) {
    return IconButton(onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },
                   icon: Icon(Icons.delete));
  }

  IconButton listTileLeadingWidget(TaskModel task) {
    return IconButton(
                    onPressed: () {
                      setState(() {
                        task.changeDoneValue();
                      });
                    }, 
                    icon: Icon(
                      task.done ? Icons.check_circle
                      : Icons.flaky_sharp,
                      color: task.done ? Colors.green 
                      : Colors.red,
                    ), );
  }
}


class TaskModel {
  String title;
  bool done;

  TaskModel({required this.title, this.done = false});

  void changeDoneValue() => done = !done;
}