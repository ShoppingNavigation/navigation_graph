class Node {
  /// Name of the node, needs to be unique
  final String name;

  /// x coordinate for displaying
  double? X;

  /// y coordinate for displaying
  double? Y;

  /// contains a list of adjacent nodes and the respective distance
  Map<Node, double>? _adjacentNodes;

  Node(this.name, {this.X, this.Y});

  /// sets the adjacent nodes of [this]
  /// DO NOT USE WHEN YOU DO NOT KNOW EXACTLY WHAT YOU DO
  /// THIS CAN BREAK THE UI
  void setAdjacentNodes(Map<Node, double> adjacentNodes) {
    _adjacentNodes = adjacentNodes;
  }

  /// gets all adjacent nodes
  get adjacentNodes => _adjacentNodes;

  /// Checks if a given node [other] is the same as this
  bool equals(Node other) {
    return name == other.name;
  }

  @override
  String toString() => name;
}
