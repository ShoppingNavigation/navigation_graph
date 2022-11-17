import 'package:store_navigation_graph/store_navigation_graph.dart';

void main() {
  final Node nodeA = Node('A');
  final Node nodeB = Node('B');
  final NavigationGraph graph = NavigationGraph(nodes: [nodeA, nodeB]);

  // create an unidirectional connection between node a and node b
  // (no need to do '.connect(nodeB, nodeA)' as well)
  graph.connect(nodeA, nodeB, 2);

  final RouteToResult? result = graph.routeTo(nodeA, nodeB);

  print('Distance between node A and node B:  ${result?.distance}');
  print('Using route: ${result?.route}');
}
