import 'package:store_navigation_graph/src/graph/node.dart';

class RouteToAllResult<TNode extends Node> {
  final List<List<TNode>> route;
  final double distance;

  const RouteToAllResult({required this.distance, required this.route});
}
