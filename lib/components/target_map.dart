class TargetsMap {
  static final Map<String, String> targets = {};

  static void updateTargets(Map<String, String> newTargets) {
    targets.clear();
    targets.addAll(newTargets);
  }

  static String? getTargetId(String userId) {
    return targets[userId];
  }
}
