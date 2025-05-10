import '../bin/node.dart';

class Grid {
  int width, height; // grid boyutları
  List<List<Node>> grid; // grid üzerindeki düğümleri tutan liste
  Node? start, goal; // S ve G düğümleri

  Grid(this.width, this.height) 
      : grid = List.generate(
            height, (y) => List.generate(width, (x) => Node(x, y)));

  void setStart(int x, int y) =>
      start = grid[y][x]; // S koordinatlarını ayarlar 
  void setGoal(int x, int y) =>
      goal = grid[y][x]; // G koordinatlarını ayarlar

  void addWall(int x, int y) => grid[y][x].isWall = true; // duvar ekler

  Node getNode(int x, int y) => grid[y][x]; // bulunduğu noktadaki düğümü alır
}