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

  // min deux joueurs dans la liste
  if (usersListCopy.length < 2) {
    return kills;
  }

  // Génération des "kills" pour chaque joueur dans la liste
  for (int i = 0; i < usersListCopy.length - 1; i++) {
    String idKiller = usersListCopy[i].id;
    String idCible = usersListCopy[i + 1].id;

    // Vérifie si le killer et la cible sont de la même famille
    String familleKiller = usersListCopy[i]['family'];
    String familleCible = usersListCopy[i + 1]['family'];
    if (familleKiller == familleCible) {
      // Si le killer et la cible sont de la même famille, passe au joueur suivant
      continue;
    }

    // Création d'un ID unique pour chaque "kill" 
    String idKill = Random().nextInt(1000000).toString();

    // Création du "kill" avec l'état initial enCours
    kills.add(Kill(
      id: idKill,
      idCible: idCible,
      idKiller: idKiller,
      etat: KillState.enCours,
    ));
  }

  return kills;
}
