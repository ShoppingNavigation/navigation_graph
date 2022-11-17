import 'package:store_navigation_graph/store_navigation_graph.dart';

void main() {
  final v0 = Node('v0');
  final v1 = Node('v1');
  final v2 = Node('v2');
  final v3 = Node('v3');
  final v4 = Node('v4');
  final v5 = Node('v5');
  final v6 = Node('v6');
  final v7 = Node('v7');
  final v8 = Node('v8');
  final v9 = Node('v9');
  final NavigationGraph graph = NavigationGraph(nodes: [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9]);

  graph.connect(v0, v1, 3);
  graph.connect(v0, v2, 5);
  graph.connect(v0, v3, 1);
  graph.connect(v1, v4, 1);
  graph.connect(v4, v6, 1);
  graph.connect(v6, v8, 2);
  graph.connect(v6, v9, 4);
  graph.connect(v8, v9, 3);
  graph.connect(v2, v9, 3);
  graph.connect(v2, v5, 4);
  graph.connect(v3, v5, 2);
  graph.connect(v5, v7, 1);
  graph.connect(v5, v9, 3);
  graph.connect(v7, v9, 3);

  final RouteToResult? routeToResult = graph.routeTo(v0, v9);
  print('Distance between node v0 and node v9:  ${routeToResult?.distance}');
  print('Using route: ${routeToResult?.route}');

  print('---');

  final RouteToAllResult? routeToAllResult = graph.routeToAll(v0, [v4, v5]);
  print('Distance between node v0 and nodes v4, v5:  ${routeToAllResult?.distance}');
  print('Using route: ${routeToAllResult?.route}');
}
