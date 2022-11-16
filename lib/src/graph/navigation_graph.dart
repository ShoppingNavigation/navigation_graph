import 'package:store_navigation_graph/src/graph/node.dart';
import 'package:store_navigation_graph/src/graph/results/dijkstra_result.dart';
import 'package:store_navigation_graph/src/graph/results/route_to_all_result.dart';
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
        adjacentNodes.putIfAbsent(
            _nodes.elementAt(i), () => possibleAdjacentNodes[i]);
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
    final result = _dijkstra(start);

    if (result.distances[destination] == double.infinity ||
        result.previous.isEmpty ||
        result.previous[destination] == null) {
      return null;
    }

    return RouteToResult(result.distances[destination]!,
        _spanningTreeToRoute(result.previous, start, destination));
  }

  /// Calculates a route from [start] to all items in [destinations] in a consecutive way
  /// does so by searching the closest node from start to any in destination and then
  /// from new found destination to any in destination and so on
  RouteToAllResult routeToAll(Node start, List<Node> destinations) {
    final route = <Node>[];
    double distance = 0;
    for (int i = 0; i < destinations.length; i++) {
      final result = _dijkstra(start);
      for (var element in result.distances.entries
          .where((element) => element.key != start)) {
        // take the first element that matches any item in desinations and add it the route.
        // remove it from the destinations
        if (destinations.contains(element.key)) {
          route.addAll(
              _spanningTreeToRoute(result.previous, start, element.key));
          distance += result.distances[element.key]!;
          destinations.remove(element.key);
          start = element.key;
          break;
        }
      }
    }

    return RouteToAllResult(distance: distance, route: route);
  }

  /// calculates the route from a spanning tree
  List<Node> _spanningTreeToRoute(
      Map<Node, Node?> spanningTree, Node start, Node destination) {
    final route = <Node>[destination];
    while (route.last != start) {
      if (spanningTree[route.last] == null) {
        break;
      }
      route.add(spanningTree[route.last]!);
    }
    return route.reversed.toList();
  }

  /// Calculates a spanning tree by using dijkstra
  /// distances are always sorted from lowest to highest
  DijkstraResult _dijkstra(Node start) {
    final distances = <Node, double>{};
    final previous = <Node, Node?>{};
    // todo: replace with fibonacci or brodal queue for faster computation (O(e*log n) instead of O(n**2))
    final remaining = PriorityQueue<Node>()..addWithPriority(0, start);
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

    return DijkstraResult(
      distances: Map.fromEntries(distances.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value))),
      previous: previous,
    );
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
