class ussdModel {
  int? id;
  int? numeros;
  int? montant;
  int? status;

  ussdModel({this.id, this.numeros, this.montant, this.status});
  factory ussdModel.fromMap(Map<dynamic, dynamic> json) {
    return ussdModel(
      id: json['id'],
      numeros: json['numeros'],
      montant: json['montant'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "numeros": numeros,
      "montant": montant,
      "status": status,
    };
  }
}
