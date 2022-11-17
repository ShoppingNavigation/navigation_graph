import 'package:store_navigation_graph/src/graph/node.dart';

class RouteToResult {
  /// the total distance from start to destination
  final double distance;

  /// all the steps required from start to desination
  final List<Node> route;

  const RouteToResult(this.distance, this.route);
}
