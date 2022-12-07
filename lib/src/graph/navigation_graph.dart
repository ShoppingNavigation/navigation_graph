import 'package:store_navigation_graph/src/graph/edge.dart';
import 'package:store_navigation_graph/src/graph/node.dart';
import 'package:store_navigation_graph/src/graph/results/dijkstra_result.dart';
import 'package:store_navigation_graph/src/graph/results/route_to_all_result.dart';
import 'package:store_navigation_graph/src/graph/results/route_to_result.dart';

import '../utils/priority_queue.dart';

typedef AdjacencyMatrix = List<List<double>>;

/// Quasi-Immutable navigation graph
/// The generic type adds support for custom node types in ui package
class NavigationGraph<TNode extends Node> {
  final List<TNode> nodes;
  late AdjacencyMatrix _adjacencyMatrix;

  NavigationGraph({required this.nodes}) {
    _adjacencyMatrix = _adjacencyTableFromTNodes(nodes.length);
  }

  /// Generates an empty adjacency table from a given [size]
  AdjacencyMatrix _adjacencyTableFromTNodes(int size) {
    AdjacencyMatrix matrix = [];
    for (int i = 0; i < size; i++) {
      matrix.add([]);
      for (int j = 0; j < size; j++) {
        matrix[i].add(0);
      }
    }
    return matrix;
  }

  /// refreshes the adjacent nodes of every node object in [nodes]
  void _refreshAdjacentTNodes(List<TNode> nodes) {
    for (final node in nodes) {
      node.setAdjacentNodes(getAdjacentTNodes(node));
    }
  }

  /// Returns a map of all adjacent nodes of [node] with their respective distance
  Map<TNode, double> getAdjacentTNodes(TNode node) {
    final possibleAdjacentTNodes = _adjacencyMatrix[nodes.indexOf(node)];
    final adjacentTNodes = <TNode, double>{};
    for (int i = 0; i < possibleAdjacentTNodes.length; i++) {
      if (possibleAdjacentTNodes[i] != 0) {
        adjacentTNodes.putIfAbsent(nodes.elementAt(i), () => possibleAdjacentTNodes[i]);
      }
    }

    return adjacentTNodes;
  }

  /// returns a list of all edges.
  /// Every edge only exists once in this list
  List<Edge<TNode>> generateEdgeTable() {
    final edges = <Edge<TNode>>[];
    for (final node in nodes) {
      for (final adjacentTNode in node.adjacentNodes<TNode>().entries) {
        // if some constellation of these two nodes already exist in the edge table
        // we skip this round
        if (edges.any((element) => element.first.equals(node) && element.second.equals(adjacentTNode.key)) ||
            edges.any((element) => element.first.equals(adjacentTNode.key) && element.second.equals(node))) {
          continue;
        }

        edges.add(Edge(node, adjacentTNode.key, distance: adjacentTNode.value));
      }
    }

    return edges;
  }

  /// Connects the two nodes [first] and [second] through an edge with a length of [distance]
  void connect(TNode first, TNode second, double distance) {
    final firstPosition = nodes.indexOf(first);
    final secondPosition = nodes.indexOf(second);

    _adjacencyMatrix[firstPosition][secondPosition] = distance;
    _adjacencyMatrix[secondPosition][firstPosition] = distance;
    _refreshAdjacentTNodes([first, second]);
  }

  /// Connects the two nodes named [first] and [second] through an edge with a length of [distance]
  void connectNamed(String first, String second, double distance){
    final firstNode = nodes.firstWhere((e) => e.name == first);
    final secondNode = nodes.firstWhere((e) => e.name == second);
    final firstPosition = nodes.indexOf(firstNode);
    final secondPosition = nodes.indexOf(secondNode);

    _adjacencyMatrix[firstPosition][secondPosition] = distance;
    _adjacencyMatrix[secondPosition][firstPosition] = distance;
    _refreshAdjacentTNodes([firstNode, secondNode]);
  }

  /// Routes the user from the [start] to the chosen [destination]
  /// uses the dijkstra algorithm to find the shortest path
  /// Returns the route and the distance. Result is null if no route was found
  RouteToResult<TNode>? routeTo(TNode start, TNode destination) {
    final result = _dijkstra(start);

    if (result.distances[destination] == double.infinity ||
        result.previous.isEmpty ||
        result.previous[destination] == null) {
      return null;
    }

    return RouteToResult(result.distances[destination]!, _spanningTreeToRoute(result.previous, start, destination));
  }

  /// Calculates a route from [start] to all items in [destinations] in a consecutive way
  /// does so by searching the closest node from start to any in destination and then
  /// from new found destination to any in destination and so on
  /// Returns null if at least one node cannot be reached
  RouteToAllResult<TNode>? routeToAll(TNode start, List<TNode> destinations) {
    final List<List<TNode>> route = [];
    double distance = 0;

    // the i < destinations.length gets evaluated every time, so we need to use a predefined
    // variable here
    final iterations = destinations.length;
    for (int i = 0; i < iterations; i++) {
      final result = _dijkstra(start);
      for (var element in result.distances.entries.where((element) => element.key != start)) {
        if (destinations.contains(element.key)) {
          if (result.distances[element.key]!.isInfinite) {
            return null;
          }
          route.add(_spanningTreeToRoute(result.previous, start, element.key));
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
  List<TNode> _spanningTreeToRoute(Map<TNode, TNode?> spanningTree, TNode start, TNode destination) {
    final route = <TNode>[destination];
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
  DijkstraResult<TNode> _dijkstra(TNode start) {
    final distances = <TNode, double>{};
    final previous = <TNode, TNode?>{};
    // todo: replace with fibonacci or brodal queue for faster computation (O(e*log n) instead of O(n**2))
    final remaining = PriorityQueue<TNode>()..addWithPriority(0, start);
    for (final node in nodes) {
      if (node != start) {
        distances[node] = double.infinity;
        previous[node] = null;
      }
    }
    distances[start] = 0;

    while (remaining.isNotEmpty) {
      final n = remaining.popMin();
      final adjacentNodes = n.adjacentNodes<TNode>();
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
      distances: Map.fromEntries(distances.entries.toList()..sort((a, b) => a.value.compareTo(b.value))),
      previous: previous,
    );
  }

  /// gets the size of the graph
  get nodeCount => nodes.length;

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
