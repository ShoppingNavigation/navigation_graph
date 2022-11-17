A package containing a simple graph implementation and important graph algorithms for pathfinding to specific nodes.

## Features

With this package you are able to
- create a simple graph with as many nodes as you want
- connect multiple nodes
- pathfind from any node to any other node (1:1 routing)
- pathfind from any node to a list of other nodes (1:1^n routing, meaning creating a route to n nodes without re-visiting the first node)

Currently the underlaying routing algorithm is implemented with dijkstra and a navie priority queue. Support for a fibonacci queue is planned.

## Getting started

To use this package you just need to import it. Since this package is not published on `pub.dev` or any other package repository, you need to import it from github:
```yaml
dependencies:
    store_navigation_graph:
        git:
            url: https://github.com/ShoppingNavigation/navigation_graph.git
            ref: main
```

## Usage

A minimal example to route in a graph with just two nodes:

```dart
final Node nodeA = Node('A');
final Node nodeB = Node('B');
final NavigationGraph graph = NavigationGraph();

// create an unidirectional connection between node a and node b
// (no need to do '.connect(nodeB, nodeA)' as well)
graph.connect(nodeA, nodeB); 

final RouteToResult result = graph.routeTo(nodeA, nodeB);
```

An example with a more complicated graph can be found in the examples folder.
The following graph was used in the example:
![test_graph](/assets/test_graph.png)