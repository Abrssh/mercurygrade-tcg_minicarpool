import 'package:collection/priority_queue.dart';

class PathFinding {
  // Variables needed to construct the graph
  final int numberOfNodes;
  final Map<int, List<int>> adjacencyList;
  final Map<int, Map<int, int>> edgeWeights;

  PathFinding(this.numberOfNodes)
      : adjacencyList = {},
        edgeWeights = {};

  void addEdge(int u, int v, int weight) {
    adjacencyList[u] ??= [];
    adjacencyList[v] ??= [];
    adjacencyList[u]!.add(v);
    adjacencyList[v]!.add(u);

    edgeWeights[u] ??= {};
    edgeWeights[v] ??= {};
    edgeWeights[u]![v] = weight;
    edgeWeights[v]![u] = weight;
  }

  List<int> dijkstra(int start, int end) {
    final distances = List<int>.filled(numberOfNodes, 2147483647);
    final visited = List<bool>.filled(numberOfNodes, false);
    final pq = PriorityQueue<int>((a, b) => distances[a] - distances[b]);

    distances[start] = 0;
    pq.add(start);

    while (pq.isNotEmpty) {
      final u = pq.removeFirst();
      if (visited[u]) continue;
      visited[u] = true;

      for (var v in adjacencyList[u]!) {
        final newDist = distances[u] + edgeWeights[u]![v]!;
        if (newDist < distances[v]) {
          distances[v] = newDist;
          pq.add(v);
        }
      }
    }
    return distances;
  }

  List<int> shortestPath(int start, int end) {
    final distances = dijkstra(start, end);
    final path = <int>[];
    int current = end;

    while (current != start) {
      path.add(current);
      for (var neighbour in adjacencyList[current]!) {
        if (distances[current] ==
            distances[neighbour] + edgeWeights[current]![neighbour]!) {
          current = neighbour;
          break;
        }
      }
    }
    path.add(start);
    return path.reversed.toList();
  }
}
