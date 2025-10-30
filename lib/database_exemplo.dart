import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {

    WidgetsFlutterBinding.ensureInitialized();
    
    final database = openDatabase(
      join(await getDatabasesPath(), 'exemplo.db'),
      onCreate:(db, version) {
        return db.execute(""
        "CREATE TABLE pets (" 
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "nome TEXT, ),"
        "idade INTEGER"
        ");");
      },
      version: 1,
    );
    print(database);

    Future<void> inserirPet(Pet pet) async {
      final db =  await database;

      await db.insert(
        "pets", 
        pet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<void> atualizarPet(Pet pet) async {
      final db =  await database;

      await db.update(
        "pets", 
        pet.toMap(),
        where: "id = ?",
        whereArgs: [pet.id]
      );
    }

    Future<void> deletarPet(int id) async {
      final db =  await database;

      await db.delete(
        "pets", 
        where: "id = ?",
        whereArgs: [id]
      );
    }

    Future<List<Pet>> recuperaTodosPets() async {
      final db = await database;
      final List<Map<String, Object?>> mapPets = await db.query("pets");
      List<Pet> result = {};

      for (final mapPet in mapPets){
        result.add(Pet(id: mapPet["id"] as int, 
        nome: mapPet["nome"] as String, 
        idade: mapPet["idade"] as int));
      }


      return result;
    }

    Pet rex = Pet(id: 0, nome: "Rex", idade: 2);
    Pet thor = Pet(id: 0, nome: "thor", idade: 10);
    print(rex);
    print(thor);

    await inserirPet(rex);
    await inserirPet(thor);

    List<Pet> pets = await recuperaTodosPets();
    print(pets);

}

class Pet {
  int id;
  String nome;
  int idade;

  Pet({
    required this.id, 
    required this.nome, 
    required this.idade
  });

// Metodo responsavel por converter a class pet em um Mapa - Chave String e Valor: Object
  Map<String, Object> toMap() {
    return {
      "id": id,
      "nome": nome,
      "idade": idade
    };
  }

  // Metodo responsavel por representar os valores de classe para String
  @override(
  String toString () {
    return "Pet(id: $id, nome: $nome, idade: $idade)";
    }
  )

}
