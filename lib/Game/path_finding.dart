import 'package:collection/priority_queue.dart';
import 'package:flutter/material.dart';

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

  // List<int> dijkstra(int start, int end) {
  //   final distances = List<int>.filled(numberOfNodes, 2147483647);
  //   final visited = List<bool>.filled(numberOfNodes, false);
  //   final pq = PriorityQueue<int>((a, b) => distances[a] - distances[b]);

  //   debugPrint(distances.join(" -> "));

  //   distances[start] = 0;
  //   pq.add(start);

  //   while (pq.isNotEmpty) {
  //     final u = pq.removeFirst();
  //     if (visited[u]) continue;
  //     visited[u] = true;

  //     for (var v in adjacencyList[u]!) {
  //       final newDist = distances[u] + edgeWeights[u]![v]!;
  //       if (newDist < distances[v]) {
  //         distances[v] = newDist;
  //         pq.add(v);
  //       }
  //     }
  //   }
  //   return distances;
  // }

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
    // debugPrint("SAt: T ${edgeWeights[path[1]]![path[0]].toString()}");
    debugPrint("SAt: ${path.reversed.toList().join(" => ")}");
    return path.reversed.toList();
  }

  // calculate emission based on the path
  int calculateEmission(List<int> paths) {
    int emissions = 0;
    for (var i = 0; i < paths.length - 1; i++) {
      emissions += edgeWeights[paths[i]]![paths[i + 1]]!;
    }
    // debugPrint("CE: ${paths.join(" => ")} pl ${paths.length}");
    // debugPrint("CE: ${emissions.toString()}");
    return emissions;
  }

  // Remove the path from the graph so that the road is blocked
  void removeEdge(int u, int v) {
    adjacencyList[u]?.remove(v);
    adjacencyList[v]?.remove(u);

    edgeWeights[u]?.remove(v);
    edgeWeights[v]?.remove(u);

    // Adjust node numbers if needed
    adjacencyList[u]?.forEach((neighbor) {
      edgeWeights[u]![neighbor] = edgeWeights[u]![neighbor]!;
    });

    adjacencyList[v]?.forEach((neighbor) {
      edgeWeights[v]![neighbor] = edgeWeights[v]![neighbor]!;
    });

    // Remove v from the adjacency list of u
    adjacencyList[u]?.remove(v);

    // Remove u from the adjacency list of v
    adjacencyList[v]?.remove(u);
  }

  bool areNodesConnected(int u, int v) {
    final visited = List<bool>.filled(numberOfNodes, false);
    dfs(u, visited);

    // Check if the destination node is visited after DFS from the source node
    return visited[v];
  }

  void dfs(int start, List<bool> visited) {
    if (visited[start]) return;

    visited[start] = true;
    for (final neighbor in adjacencyList[start]!) {
      dfs(neighbor, visited);
    }
  }
}
