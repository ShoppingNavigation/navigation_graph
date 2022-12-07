import 'package:store_navigation_graph/store_navigation_graph.dart';
import 'package:test/test.dart';

void main() {
  group('Plain Graph Theory -', () {

    test('Should create a graph', () {
      var graph = NavigationGraph(nodes: [Node('A')]);
      assert(graph.nodeCount == 1);
    });

    test('Should add connection to graph', () {
      final a = Node('A');
      final b = Node('B');
      final graph = NavigationGraph(nodes: [a, b]);

      graph.connect(a, b, 5);

      final adjacentToA = a.adjacentNodes();
      assert(adjacentToA.length == 1);
      assert(adjacentToA.keys.first == b);
      assert(adjacentToA.values.first == 5);
    });

    test('Should add connection by node names to graph', () {
      final a = Node('A');
      final b = Node('B');
      final graph = NavigationGraph(nodes: [a, b]);

      graph.connectNamed('A', 'B', 5);

      final adjacentToA = a.adjacentNodes();
      assert(adjacentToA.length == 1);
      assert(adjacentToA.keys.first == b);
      assert(adjacentToA.values.first == 5);
    });

    test('Should generate correct edge table', () {
      final a = Node('A');
      final b = Node('B');
      final graph = NavigationGraph(nodes: [a, b]);

      graph.connect(a, b, 5);

      final edgeTable = graph.generateEdgeTable();
      assert(edgeTable.length == 1);
      assert(edgeTable.first.first == a);
      assert(edgeTable.first.second == b);
    });
  });

  group('Pathfinding in Graph to single Node -', () {
    NavigationGraph? graph;
    final v0 = Node('v0');
    final v1 = Node('v1');
    final v2 = Node('v2');
    final v3 = Node('v3');
    final v4 = Node('v4');
    final v5 = Node('v5');
    final v6 = Node('v6');
    final v7 = Node('v7');
    final v8 = Node('v8');
    final v9 = Node('v9');
    final unconnected = Node('U');

    setUp(() {
      graph = NavigationGraph(
          nodes: [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, unconnected]);

      graph!.connect(v0, v1, 3);
      graph!.connect(v0, v2, 5);
      graph!.connect(v0, v3, 1);
      graph!.connect(v1, v4, 1);
      graph!.connect(v4, v6, 1);
      graph!.connect(v6, v8, 2);
      graph!.connect(v6, v9, 4);
      graph!.connect(v8, v9, 3);
      graph!.connect(v2, v9, 3);
      graph!.connect(v2, v5, 4);
      graph!.connect(v3, v5, 2);
      graph!.connect(v5, v7, 1);
      graph!.connect(v5, v9, 3);
      graph!.connect(v7, v9, 3);
    });

    test('Should find valid path (Case 1)', () {
      final result = graph!.routeTo(v0, v9);

      assert(result != null);
      assert(result!.distance == 6);
      assert(result!.route.length == 4);
      assert(result!.route[0] == v0);
      assert(result!.route[1] == v3);
      assert(result!.route[2] == v5);
      assert(result!.route[3] == v9);
    });

    test('Should find valid path (Case 2)', () {
      final result = graph!.routeTo(v2, v6);

      assert(result != null);
      assert(result!.distance == 7);
      assert(result!.route.length == 3);
      assert(result!.route[0] == v2);
      assert(result!.route[1] == v9);
      assert(result!.route[2] == v6);
    });

    test('Should fail when not connected', () {
      final result = graph!.routeTo(v0, unconnected);

      assert(result == null);
    });
  });

  group('Pathfinding in Graph to multiple Nodes - ', () {
    NavigationGraph? graph;
    final v0 = Node('v0');
    final v1 = Node('v1');
    final v2 = Node('v2');
    final v3 = Node('v3');
    final v4 = Node('v4');
    final v5 = Node('v5');
    final v6 = Node('v6');
    final v7 = Node('v7');
    final v8 = Node('v8');
    final v9 = Node('v9');
    final unconnected = Node('U');

    setUp(() {
      graph = NavigationGraph(
          nodes: [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, unconnected]);

      graph!.connect(v0, v1, 3);
      graph!.connect(v0, v2, 5);
      graph!.connect(v0, v3, 1);
      graph!.connect(v1, v4, 1);
      graph!.connect(v4, v6, 1);
      graph!.connect(v6, v8, 2);
      graph!.connect(v6, v9, 4);
      graph!.connect(v8, v9, 3);
      graph!.connect(v2, v9, 3);
      graph!.connect(v2, v5, 4);
      graph!.connect(v3, v5, 2);
      graph!.connect(v5, v7, 1);
      graph!.connect(v5, v9, 3);
      graph!.connect(v7, v9, 3);
    });

    test('Should find valid route (Case 1)', () {
      final result = graph!.routeToAll(v0, [v1, v3]);

      assert(result != null);
      assert(result!.distance == 5);
      assert(result!.route[0][0] == v0);
      assert(result!.route[0][1] == v3);
      assert(result!.route[1][0] == v3);
      assert(result!.route[1][1] == v0);
      assert(result!.route[1][2] == v1);
    });

    test('Should find valid route (Case 2)', () {
      final result = graph!.routeToAll(v0, [v6, v7]);

      assert(result != null);
      assert(result!.distance == 11);
      assert(result!.route[0][0] == v0);
      assert(result!.route[0][1] == v3);
      assert(result!.route[0][2] == v5);
      assert(result!.route[0][3] == v7);
      assert(result!.route[1][0] == v7);
      assert(result!.route[1][1] == v9);
      assert(result!.route[1][2] == v6);
    });

    test('Should fail when not connected', () {
      final result = graph!.routeToAll(v0, [unconnected]);

      assert(result == null);
    });
  });
}
