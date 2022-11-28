import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/models/livre.dart';
import 'package:bibliotheca/views/edition_livre.dart';
import 'package:flutter/material.dart';

class ListeLivrePage extends StatefulWidget {
  const ListeLivrePage({Key? key}) : super(key: key);

  @override
  State<ListeLivrePage> createState() => _ListeLivrePageState();
}

class _ListeLivrePageState extends State<ListeLivrePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Liste des livres"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => ouvrirEdition(),
        ),
        body: FutureBuilder<List<Livre>>(
            future: Dao.listeLivre(),
            initialData: const [],
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  Livre livre = snapshot.data![i];
                  return ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(livre.libelle!),
                    subtitle: Text(livre.description!),
                    onTap: () => ouvrirEdition(livre: livre),
                    trailing: IconButton(
                      onPressed: () => onDelete(livre),
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              );
            }),
      );

  ouvrirEdition({Livre? livre}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditionLivre(
          livre: livre,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> onDelete(Livre livre) async {
    await Dao.deleteLivre(livre.id!);
    setState(() {});
  }
}
