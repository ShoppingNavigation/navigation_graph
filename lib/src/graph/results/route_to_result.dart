import 'package:store_navigation_graph/src/graph/node.dart';

class RouteToResult<TNode extends Node> {
  /// the total distance from start to destination
  final double distance;

  /// all the steps required from start to desination
  final List<TNode> route;

  const RouteToResult(this.distance, this.route);
}
