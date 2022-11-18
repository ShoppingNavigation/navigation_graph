import 'package:store_navigation_graph/store_navigation_graph.dart';

class Edge {
  /// first connected node
  final Node first;
  /// second connected node
  final Node second;

  /// distance between both nodes
  final double distance;

  const Edge(this.first, this.second, {required this.distance});
}
