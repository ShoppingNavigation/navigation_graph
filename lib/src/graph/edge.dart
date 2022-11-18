import 'package:store_navigation_graph/store_navigation_graph.dart';

class Edge<TNode extends Node> {
  /// first connected node
  final TNode first;
  /// second connected node
  final TNode second;

  /// distance between both nodes
  final double distance;

  const Edge(this.first, this.second, {required this.distance});
}
