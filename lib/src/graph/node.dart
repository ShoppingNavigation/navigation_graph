class Node {
  /// Name of the node, needs to be unique
  final String name;

  const Node(this.name);

  /// gets the distance to a given node
  // double distanceTo(Node node) {
  //   if (!neighbours.containsKey(node)) {
  //     throw Exception('Node ${node.name} does not exist as a neighbour of $name');
  //   }

  //   return neighbours[node]!;
  // }

  /// Checks if a given node [other] is the same as this
  bool equals(Node other) {
    return name == other.name;
  }

  @override
  String toString() => name;
}
