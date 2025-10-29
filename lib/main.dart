import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _userName;

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

  @override
  void initState() {
    super.initState();


    _initPreferences();
  }

  Future<void> _initPreferences()  async {
    final prefs =  await SharedPreferences.getInstance();
    
    // prefs.remove("local_user");

    if (prefs.containsKey("local_user")) {
      setState(() {
        _userName = prefs.getString("local_user");
      });
    } else {
      showSetUserDialog();
    }
  }

  // Metodo Responsavel por exibir uma caixa de dialog para usuario informar seu nome
  void showSetUserDialog() {
    TextField textFieldUserName = TextField(
      controller: TextEditingController() ,
      decoration: InputDecoration(hintText: "Coloque seu Nome"),
    );

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          title: Text("Bem-Vindo!!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textFieldUserName,
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String userName = textFieldUserName.controller!.text;
                if (userName.isEmpty) return;

                final prefs =  await SharedPreferences.getInstance();

                await prefs.setString("local_user", userName);


                setState(() {
                  _userName =  userName;
                  Navigator.of(context).pop();
                });
              }, 
              child: Text("Salvar")
            ),
          ],
        );
      }
    );
  }


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
  Widget taskAppBody() => Column(
    children: [
        // dashboard
        tasksDashboard(),
        Expanded(
          child: tasksListView(),
        ),
      taskFooterBar(),
    ],
  );

  Widget tasksDashboard() => Row(
    children: [
      // Contador/Indicador de Tarefas
      Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 8, 0), 
        child: Text(
          "(${tasks.where((tasks) => tasks.done).length}/${tasks.length})",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      
      // progressbar
      Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
          child: LinearProgressIndicator(
            value: tasks.where((tasks) => tasks.done).length / tasks.length,
            // valueColor: AlwaysStoppedAnimation(Colors.green)
            color: Colors.green,
          ),
        ),
      ),
    ],  
  );

  Widget tasksListView() => ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final TaskModel task = tasks[index];
        return ListTile(
          leading: listTileLeadingWidget(task), 
          trailing: listItemTrailingWidget(index),
          title: Text(task.title)
        );
      }
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
                  ), 
            );
      }
      
      Widget taskFooterBar() {
        return Container(
          padding: EdgeInsets.only(left: 16),
          height: 40.00,
          alignment: Alignment.topLeft,
          child: Text(
            "Usuario: ${_userName ?? "Desconhecido"}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        );
      }
    }

class TaskModel{
  String title;
  bool done;

  TaskModel({required this.title, this.done = false});

  void changeDoneValue() => done = !done;
}
