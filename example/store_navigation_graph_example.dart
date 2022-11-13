import 'package:store_navigation_graph/src/graph/node.dart';
import 'package:store_navigation_graph/store_navigation_graph.dart';

void main() {
  final a = Node('A');
  final b = Node('B');
  final c = Node('C');
  final d = Node('D');
  final e = Node('E');

  final graph = NavigationGraph(nodes: [a, b, c, d, e]);

  graph.connect(a, b, 5);
  graph.connect(a, d, 1);
  graph.connect(b, c, 3);
  graph.connect(b, e, 7);
  graph.connect(c, e, 2);
  graph.connect(d, e, 3);

  print(graph);

  graph.routeTo(a, c);
}
