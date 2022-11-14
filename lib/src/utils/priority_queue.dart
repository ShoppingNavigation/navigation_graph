import 'dart:collection';

/// Very naive priority queue
class PriorityQueue<T> {
  final Map<int, Queue<T>> _pseudoQueue = <int, Queue<T>>{};
  int _length = 0;

  int Function(T)? _priorityFunction;

  PriorityQueue(int Function(T) priorityFunction) : _priorityFunction = priorityFunction;
  PriorityQueue.withOutPriorityFunction();

  /// Adds a new [value] and calculates the priority using [_priorityFunction]
  /// throws if [_priorityFunction] is null
  void add(T value) {
    if (_priorityFunction == null) {
      throw Exception('Priority function may not be null when using "add" in priority queue');
    }

    var priority = _priorityFunction!(value);
    addWithPriority(priority, value);
  }

  /// Adds a new [value] to the priority queue with a given [priority]
  void addWithPriority(int priority, T value) {
    _length += 1;
    if (_pseudoQueue.containsKey(priority)) {
      _pseudoQueue[priority]!.add(value);
      return;
    }

    _pseudoQueue[priority] = Queue()..add(value);
  }

  /// Pops the next value for the current minimum
  T popMin() {
    _length -= 1;
    final internalQueue = _pseudoQueue.entries.where((element) => element.value.isNotEmpty).toList();
    internalQueue.sort((a, b) => a.key - b.key);
    final minPriority = internalQueue.first.key;

    return _pseudoQueue[minPriority]!.removeFirst();
  }

  /// checks if a provided value is already somewhere in the queue
  bool isInQueue(T value) {
    for (final subqueue in _pseudoQueue.entries) {
      if (subqueue.value.contains(value)) {
        return true;
      }
    }
    return false;
  }

  get isEmpty => _length == 0;
  get isNotEmpty => _length != 0;

  @override
  String toString() {
    return '$_length items';
  }
}
