class Node {
  /// Name of the node, needs to be unique
  final String name;

  /// x coordinate for displaying
  double? X;

  /// y coordinate for displaying
  double? Y;

  Node(this.name, {this.X, this.Y});

  /// Checks if a given node [other] is the same as this
  bool equals(Node other) {
    return name == other.name;
  }

  @override
  String toString() => name;
}
