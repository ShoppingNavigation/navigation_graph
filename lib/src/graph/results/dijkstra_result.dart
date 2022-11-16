import 'package:store_navigation_graph/src/graph/node.dart';

class DijkstraResult {
  final Map<Node, double> distances;
  final Map<Node, Node?> previous;

  const DijkstraResult({required this.distances, required this.previous});
}
