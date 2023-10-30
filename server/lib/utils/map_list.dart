class MapList<K, V> {
  final Map<K, V> _map = {};
  final List<V> list = [];

  void add(K key, V value) {
    _map[key] = value;
    list.add(value);
  }

  V get(K key) => _map[key]!;

  bool has(K key) => _map.containsKey(key);
}
