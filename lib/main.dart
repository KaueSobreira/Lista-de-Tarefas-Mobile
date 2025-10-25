import 'package:flutter/material.dart';

void main() {
  runApp(const TaskApp());
}

//Classe Responsável por implementar a abstração de MaterialApp
class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(home: TaskListPage());
  }
}


//Classe Responsável por implementar a representação da página Dinâmica de Lista de Tarefas
class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override 
    State<TaskListPage> createState() => _TaskListPageState();
}


//Classe Responsável por implementar o gerenciamento do Estado da página "TaskListPage"
class _TaskListPageState extends State<TaskListPage> {
  final List<TaskModel> tasks = [
    TaskModel(title: "Preparar conteúdo da Aula"),
    TaskModel(title: "Jogar Cszin"),
    TaskModel(title: "Arrumar as contas para Pagar"),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: taskAppBar(),
      floatingActionButton: taskAppFloatingActionButton(),
      body: taskAppBody()
    );



  //Metodo responsabel por criar o AppBar da Pagina Lista de Tarefas
  AppBar taskAppBar() => AppBar(title: Center(child: Text("Lista de Tarefas")));
  //Metodo responsabel por criar o FloatingActionButton da Pagina Lista de Tarefas
  FloatingActionButton taskAppFloatingActionButton() => FloatingActionButton(child: Icon(Icons.add),onPressed: createTaskDialog());

  VoidCallback createTaskDialog(){
    TextField  textFieldTaskTitle = TextField(
      controller: TextEditingController(),
      decoration: InputDecoration(hintText: "Digite a Tarefa")
    );

    return (){
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(title: Text("Adicionar Tarefa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textFieldTaskTitle
              ],
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Cancelar")),
              TextButton(onPressed: (){
                setState(() {
                  String taskTitle = textFieldTaskTitle.controller!.text;
                if (taskTitle.isEmpty) return;

                tasks.add(TaskModel(title: taskTitle));
                Navigator.of(context).pop();
                });

                
              }, child: Text("Adicionar")),
            ],
            );
        }
      );
    };
  }

  //Metodo responsabel por criar o conteudo (body) da página Lista de Tarefas
  Widget taskAppBody() => Column(children: [
    Expanded(child: ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final TaskModel task = tasks[index];
        return ListTile(
          leading: listTileLeadingWidget(task), 
          trailing: listItemTrailingWidget(index),
          title: Text(task.title)
        );
      }
    ),
    ),
  ],
  );

  IconButton listItemTrailingWidget(int index) {
    return IconButton(
          onPressed: (){
            setState(() {
              tasks.removeAt(index);
            });
          }, 
          icon: Icon(Icons.delete)
        );
  }

  IconButton listTileLeadingWidget(TaskModel task) {
    return IconButton(
          onPressed: (){
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

class TaskModel{
  String title;
  bool done;

  TaskModel({required this.title, this.done = false});

  void changeDoneValue() => done = !done;
}
