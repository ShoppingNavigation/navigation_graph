import 'package:store_navigation_graph/src/graph/node.dart';

class DijkstraResult<TNode extends Node> {
  final Map<TNode, double> distances;
  final Map<TNode, TNode?> previous;

  const DijkstraResult({required this.distances, required this.previous});
}
