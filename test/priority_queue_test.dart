import 'package:store_navigation_graph/src/utils/priority_queue.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Priority Queue -', () {
    test('Should add with priority', () {
      final queue = PriorityQueue<int>();
      queue.addWithPriority(3, 2);
      assert(queue.isNotEmpty);
      // ignore: prefer_is_not_empty
      assert(!queue.isEmpty);
      assert(queue.size == 1);
    });

    test('Should pop min', () {
      final queue = PriorityQueue<int>();
      queue.addWithPriority(2, 3);
      queue.addWithPriority(5, 7);

      assert(queue.popMin() == 3);
      assert(queue.popMin() == 7);
    });

    test('Should add with priority function', () {
      const priorities = <int, int>{3: 2, 7: 5};

      final queue = PriorityQueue<int>.withPriorityFunction((p0) => priorities[p0]!);
      queue.add(3);
      queue.add(7);

      assert(queue.popMin() == 3);
      assert(queue.popMin() == 7);
    });
  });
}
