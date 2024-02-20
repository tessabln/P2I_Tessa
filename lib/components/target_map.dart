class TargetsMap {
  static final Map<String, String> targets = {};

  static void updateTargets(Map<String, String> newTargets) {
    targets.clear();
    targets.addAll(newTargets);
  }

  static String? getTargetId(String userId) {
    // Afficher le contenu de la carte `targets`
    print('Contenu de la carte `targets`: ${TargetsMap.targets}');
    return targets[userId];
  }
}
