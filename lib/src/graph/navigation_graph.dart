import 'package:store_navigation_graph/src/graph/node.dart';
import 'package:store_navigation_graph/src/graph/results/route_to_result.dart';

import '../utils/priority_queue.dart';

typedef AdjacencyMatrix = List<List<double>>;

/// Quasi-Immutable navigation graph
class NavigationGraph {
  final List<Node> _nodes;
  late AdjacencyMatrix _adjacencyMatrix;

  NavigationGraph({required List<Node> nodes}) : _nodes = nodes {
    _adjacencyMatrix = _adjacencyTableFromNodes(_nodes.length);
  }

  /// Generates an empty adjacency table from a given [size]
  AdjacencyMatrix _adjacencyTableFromNodes(int size) {
    AdjacencyMatrix matrix = [];
    for (int i = 0; i < size; i++) {
      matrix.add([]);
      for (int j = 0; j < size; j++) {
        matrix[i].add(0);
      }
    }
    return matrix;
  }

  /// Returns a map of all adjacent nodes of [node] with their respective distance
  Map<Node, double> getAdjacentNodes(Node node) {
    final possibleAdjacentNodes = _adjacencyMatrix[_nodes.indexOf(node)];
    final adjacentNodes = <Node, double>{};
    for (int i = 0; i < possibleAdjacentNodes.length; i++) {
      if (possibleAdjacentNodes[i] != 0) {
        adjacentNodes.putIfAbsent(_nodes.elementAt(i), () => possibleAdjacentNodes[i]);
      }
    }

    return adjacentNodes;
  }

  /// Connects the two nodes [first] and [second] through an edge with a length of [distance]
  void connect(Node first, Node second, double distance) {
    final firstPosition = _nodes.indexOf(first);
    final secondPosition = _nodes.indexOf(second);

    _adjacencyMatrix[firstPosition][secondPosition] = distance;
    _adjacencyMatrix[secondPosition][firstPosition] = distance;
  }

  /// Routes the user from the [start] to the chosen [destination]
  /// uses the dijkstra algorithm to find the shortest path
  /// Returns the route and the distance. Result is null if no route was found
  RouteToResult? routeTo(Node start, Node destination) {
    final distances = <Node, double>{};
    final previous = <Node, Node?>{};
    // todo: replace with fibonacci or brodal queue for faster computation (O(e*log n) instead of O(n**2))
    final remaining = PriorityQueue<Node>((node) => distances[node]!.toInt())..addWithPriority(0, start);
    for (final node in _nodes) {
      if (node != start) {
        distances[node] = double.infinity;
        previous[node] = null;
      }
    }
    distances[start] = 0;

    while (remaining.isNotEmpty) {
      final n = remaining.popMin();
      final adjacentNodes = getAdjacentNodes(n);
      for (var neighbour in adjacentNodes.entries) {
        final newDistance = distances[n]! + neighbour.value;
        final oldBestDistance = distances[neighbour.key]!;

        if (newDistance < oldBestDistance) {
          if (!remaining.isInQueue(neighbour.key)) {
            remaining.addWithPriority(newDistance.toInt(), neighbour.key);
          }
          distances[neighbour.key] = newDistance;
          previous[neighbour.key] = n;
        }
      }
    }

    if (distances[destination] == double.infinity || previous.isEmpty || previous[destination] == null) {
      return null;
    }

    return RouteToResult(distances[destination]!, _spanningTreeToRoute(previous, start, destination));
  }

  /// calculates the route from a spanning tree
  List<Node> _spanningTreeToRoute(Map<Node, Node?> spanningTree, Node start, Node destination) {
    final route = <Node>[destination];
    while (route.last != start) {
      if (spanningTree[route.last] == null) {
        break;
      }
      route.add(spanningTree[route.last]!);
    }
    return route.reversed.toList();
  }

  /// gets the size of the graph
  get nodeCount => _nodes.length;

  @override
  String toString() {
    String s = '';
    for (var column in _adjacencyMatrix) {
      for (var row in column) {
        s += '$row ';
      }
      s += '\n';
    }
    return s;
  }
}
