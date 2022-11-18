class Node {
  /// Name of the node, needs to be unique
  final String name;

  /// contains a list of adjacent nodes and the respective distance
  /// sadly, we have to use dynamic, but the type should be TNode
  Map<dynamic, double>? _adjacentNodes;

  Node(this.name);

  /// sets the adjacent nodes of [this]
  /// DO NOT USE WHEN YOU DO NOT KNOW EXACTLY WHAT YOU DO
  /// THIS CAN BREAK THE UI
  void setAdjacentNodes(Map<Node, double> adjacentNodes) {
    _adjacentNodes = adjacentNodes;
  }

  /// gets all adjacent nodes
  Map<TNode, double> adjacentNodes<TNode extends Node>() =>
      _adjacentNodes?.map((key, value) => MapEntry(key as TNode, value)) ?? <TNode, double>{};

  /// Checks if a given node [other] is the same as this
  bool equals(Node other) {
    return name == other.name;
  }

  @override
  String toString() => name;
}
