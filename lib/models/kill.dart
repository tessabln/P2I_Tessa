enum KillState {
  enCours,
  enValidation,
  succes,
  echec,
}

class Kill {
  String idKiller;
  String idCible;
  KillState etat;

  Kill({
    required this.idKiller,
    required this.idCible,
    required this.etat,
  });

    Map<String, dynamic> toJson() {
    return {
      'idKiller': idKiller,
      'idCible': idCible,
      'etat': etat.toString(),
  };
}
}
  