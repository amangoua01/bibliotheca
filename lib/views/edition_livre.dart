import 'dart:io';

import 'package:bibliotheca/models/auteur.dart';
import 'package:bibliotheca/models/categorie.dart';
import 'package:bibliotheca/models/database/dao.dart';
import 'package:bibliotheca/models/livre.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditionLivre extends StatefulWidget {
  final Livre? livre;
  const EditionLivre({this.livre, Key? key}) : super(key: key);

  @override
  State<EditionLivre> createState() => _EditionLivreState();
}

class _EditionLivreState extends State<EditionLivre> {
  List<Categorie> catList = [];
  List<Auteur> autList = [];
  int? selectedCat;
  int? selectedAut;
  String? imgPath;
  var titre = TextEditingController();
  var description = TextEditingController();
  var nbPage = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
    if (widget.livre != null) {
      selectedAut = widget.livre!.auteurId;
      selectedCat = widget.livre!.categorieId;
      titre.text = widget.livre!.libelle!;
      description.text = widget.livre!.description ?? "";
      imgPath = widget.livre!.image;
      if (widget.livre!.nbPage != null) {
        nbPage.text = widget.livre!.nbPage.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Edition de livre"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              MaterialButton(
                onPressed: () => getImage(),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: (imgPath != null)
                      ? FileImage(File(imgPath!)) as ImageProvider
                      : null,
                ),
              ),
              TextFormField(
                validator: (e) => e!.isEmpty ? "Champ obligatoire" : null,
                controller: titre,
                decoration: const InputDecoration(labelText: "Titre du livre"),
              ),
              TextFormField(
                validator: (e) => e!.isEmpty ? "Champ obligatoire" : null,
                controller: nbPage,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nombre de page"),
              ),
              DropdownButtonFormField<int>(
                validator: (e) => e == null ? "Champ obligatoire" : null,
                value: selectedCat,
                items: catList
                    .map(
                      (e) => DropdownMenuItem<int>(
                        value: e.id,
                        child: Text(e.libelle!),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCat = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Catégorie"),
              ),
              DropdownButtonFormField<int>(
                validator: (e) => e == null ? "Champ obligatoire" : null,
                value: selectedAut,
                items: autList
                    .map(
                      (e) => DropdownMenuItem<int>(
                        value: e.id,
                        child: Text("${e.nom} ${e.prenoms}"),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAut = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Auteur"),
              ),
              TextFormField(
                controller: description,
                maxLines: 10,
                decoration:
                    const InputDecoration(labelText: "Description du livre"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => submit(),
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      );

  Future<void> getData() async {
    catList = await Dao.listeCategorie();
    autList = await Dao.listeAuteur();
    setState(() {});
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      if (widget.livre == null) {
        Livre livre = Livre();
        livre.libelle = titre.text;
        livre.auteurId = selectedAut;
        livre.categorieId = selectedCat;
        livre.description = description.text;
        livre.nbPage = int.tryParse(nbPage.text);
        livre.image = imgPath;
        Dao.createLivre(livre);
      } else {
        Livre livre = widget.livre!;
        livre.libelle = titre.text;
        livre.auteurId = selectedAut;
        livre.categorieId = selectedCat;
        livre.description = description.text;
        livre.nbPage = int.tryParse(nbPage.text);
        livre.image = imgPath;
        Dao.updateLivre(livre);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();

    var img = await picker.pickImage(source: ImageSource.gallery);

    if (img?.path != null) {
      setState(() {
        imgPath = img?.path;
      });
    }
  }
}
