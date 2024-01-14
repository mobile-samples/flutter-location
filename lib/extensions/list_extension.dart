extension UtilListExtension on List {
  groupBy(String key) {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      forEach((f) => keys.add(f[key]));

      for (var k in [...keys.toSet()]) {
        List data = [...where((e) => e[key] == k)];
        result.add({k: data});
      }

      return result;
    } catch (e) {
      return this;
    }
  }
}
