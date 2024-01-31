// Méthode pour récupérer l'UID de l'utilisateur connecté
  /*String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? "Aucun utilisateur connecté";
  }

  final user = FirebaseAuth.instance.currentUser;

  appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          // Bouton de déconnexion
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          ),
          // Bouton pour changer de thème
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Icons.nightlight_round_sharp),
          ),
        ],
      ),


      
  // Méthode pour déconnecter l'utilisateur
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }
  */