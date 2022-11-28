class Livre {
  int? id;
  String? libelle;
  String? description;
  String? image;
  int? categorieId;
  int? nbPage;
  int? auteurId;

  Livre(
      {this.id,
      this.libelle,
      this.description,
      this.image,
      this.nbPage,
      this.auteurId,
      this.categorieId});

  Livre.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    libelle = json["libelle"];
    description = json["description"];
    image = json["image"];
    categorieId = json["categorie_id"];
    auteurId = json["auteur_id"];
    nbPage = json["nb_page"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["libelle"] = libelle;
    map["description"] = description;
    map["image"] = image;
    map["categorie_id"] = categorieId;
    map["auteur_id"] = auteurId;
    map["nb_page"] = nbPage;
    return map;
  }
}
