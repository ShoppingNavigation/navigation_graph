import 'package:store_navigation_graph/src/graph/node.dart';

class RouteToAllResult {
  final List<Node> route;
  final double distance;

  const RouteToAllResult({required this.distance, required this.route});
}
