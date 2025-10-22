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
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: taskAppBar(),
      floatingActionButton: taskAppFloatingActionButton(),
      body: taskAppBody(),
    );

  AppBar taskAppBar(){
    return AppBar(
        title: Center(child: Text("Lista de Tarefas"),
        ),
      );
  }

  // Segunda opção de fazer a função
  // AppBar taskAppBar() => AppBar(title: Center(child: Text("Lista de Tarefas")));

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

  // Segunda Forma de Escrever
  Widget taskAppBody() => Column(
        children: [
          // Dashboard
          // Lista de Tarefas
        ],
      );

}