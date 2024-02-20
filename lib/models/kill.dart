import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

enum KillState {
  enCours,
  enValidation,
  succes,
  echec,
}

class Kill {
  String id;
  String idCible;
  String idKiller;
  KillState etat;

  Kill({
    required this.id,
    required this.idCible,
    required this.idKiller,
    required this.etat,
  });
}

List<Kill> generateKills(List<DocumentSnapshot> usersListCopy) {
  List<Kill> kills = [];

  // Vérifier s'il y a au moins deux joueurs dans la liste
  if (usersListCopy.length < 2) {
    return kills;
  }

  // Générer un index de départ aléatoire pour commencer à parcourir la liste des joueurs
  int startIndex = Random().nextInt(usersListCopy.length);

  // Créer une liste pour suivre les cibles déjà attribuées
  List<String> assignedTargets = [];

  // Parcourir la liste des joueurs en commençant par l'index aléatoire
  for (int i = 0; i < usersListCopy.length; i++) {
    int index = (startIndex + i) % usersListCopy.length;
    String idKiller = usersListCopy[index].id;
    String idCible = '';

    String? familleKiller = usersListCopy[index]
        ['family']; 
    for (int j = 1; j < usersListCopy.length; j++) {
      int targetIndex = (index + j) % usersListCopy.length;
      String? familleCible = usersListCopy[targetIndex]
          ['family']; 

      if (familleKiller != null &&
          familleCible != null &&
          familleKiller != familleCible &&
          !assignedTargets.contains(usersListCopy[targetIndex].id)) {
        idCible = usersListCopy[targetIndex].id;
        assignedTargets.add(idCible);
        break;
      }
    }

    if (idCible.isEmpty) {
      break;
    }

    String idKill = Random().nextInt(1000000).toString();
    kills.add(Kill(
      id: idKill,
      idCible: idCible,
      idKiller: idKiller,
      etat: KillState.enCours,
    ));

    // Affichage du kill dans la console
    print('Kill ID: $idKill, Killer ID: $idKiller, Target ID: $idCible');
  }

  return kills;
}
