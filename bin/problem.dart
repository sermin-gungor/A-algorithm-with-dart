import 'package:collection/collection.dart';
import 'dart:math';
import '../bin/grid.dart';
import '../bin/node.dart';

class Problem {
  Grid grid;
  Node start, goal;

  Problem(this.grid, this.start, this.goal); //constructor

  List<Node> aStar() {
    //a* algoritması
    var openSet = PriorityQueue<Node>((a, b) => a.f.compareTo(b
        .f)); //priorityQueue kullanarak açık küme oluşturuyoruz. yani f(n) değerime göre öncelikli sıralama yapıyoruz.
    var closedSet =
        <Node>{}; //kapalı küme oluşturuyoruz. yani daha önce ziyaret ettiğimiz düğümleri tutuyoruz

    start.g = 0; //başlangıç düğümünün g değerini 0 yapıyoruz
    start.h = heuristic(start); //başlangıç düğümünün h değerini hesaplıyoruz
    openSet.add(start); //başlangıç düğümünü açık kümeye ekliyoruz

    while (openSet.isNotEmpty) {
      //açık küme boş değilse döngüye giriyoruz
      var current = openSet
          .removeFirst(); //açık kümeden en düşük f(n) değerine sahip düğümü alıyoruz
      if (current == goal) {
        return reconstructPath(
            current); //hedef düğümüne ulaştıysak yolu geri döndürüyoruz
      }

      closedSet.add(current); //şu anki düğümü kapalı kümeye ekliyoruz
      expand(current, openSet,
          closedSet); //şu anki düğümün komşularını genişletiyoruz
    }
    return [];
  }

  void expand(Node node, PriorityQueue<Node> open, Set<Node> closed) {
    //komşuları genişletiyoruz
    var directions = [
      [-1, 0],
      [0, 1],
      [1, 0],
      [0, -1]
    ]; //komşu düğümlerin yönlerini tanımlıyoruz. yukarı, sağa, aşağı, sola
    for (var move in directions) {
      //her yön için döngüye giriyoruz
      int newX = node.x + move[0],
          newY = node.y +
              move[1]; //komşu düğümün x ve y koordinatlarını hesaplıyoruz
      if (newX < 0 || newY < 0 || newX >= grid.width || newY >= grid.height) {
        //kokmşular gridin dışındaysa bu noktayı atlıyoruz
        continue;
      }

      Node child = grid.getNode(newX, newY); //komşu düğümü alıyoruz.
      if (child.isWall || closed.contains(child)) {
        continue; //komşu düğüm duvar veya daha önce ziyaret edildiyse bu noktayı atlıyoruz
      }

      child.g = node.g +
          1; //komşu düğümün g değerini hesaplıyoruz. yani şu anki düğümün g değeri + 1
      child.h = heuristic(
          child); //komşu düğümün h değerini hesaplıyoruz. yani komşu düğümün hedefe olan uzaklığı
      child.parent =
          node; //komşu düğümün ebeveynini şu anki düğüm yapıyoruz. yani komşu düğümün ebeveyni şu anki düğüm oluyor

      if (!open.contains(child)) {
        open.add(child); //eğer komşu düğüm açık kümede yoksa ekliyoruz
      }
    }
  }

  int heuristic(Node node) =>
      (node.x - goal.x).abs() +
      (node.y - goal.y)
          .abs(); //hedef düğümüne olan uzaklığı hesaplıyoruz. yani x ve y koordinatları arasındaki mutlak farkı topluyoruz

  List<Node> reconstructPath(Node node) {
    //yolu geri döndürüyoruz
    //yani hedef düğümden başlayarak ebeveyn düğümleri takip ediyoruz
    //ve yolu oluşturuyoruz
    var path = <Node>[];
    while (node.parent != null) {
      path.add(node);
      node = node.parent!;
    }
    return path.reversed
        .toList(); //yolu ters çeviriyoruz, çünkü biz başlangıçtan hedefe doğru gitmek istiyoruz
  }

  void addWallSafe(Grid grid, int count, Node start, Node goal) {
    //duvar ekliyoruz
    var random = Random();
    int added = 0; //eklenen duvar sayısını tutuyoruz
    while (added < count) {
      //eklenen duvar sayısı istenen sayıya ulaşana kadar döngüye giriyoruz
      int x = random.nextInt(grid.width),
          y = random
              .nextInt(grid.height); //rastgele x ve y koordinatları üretiyoruz
      Node node = grid.getNode(x, y); //rastgele düğümü alıyoruz
      if (node != start && node != goal && !node.isWall) {
        //başlangıç ve hedef düğümü değilse ve daha önce eklenmediyse duvar olarak ekliyoruz
        node.isWall = true;
        added++;
      }
    }
  }

  void printPath(List<Node> path) {
    //yolu yazdırıyoruz
    for (int y = 0; y < grid.height; y++) {
      //y ekseninde döngüye giriyoruz
      String row = ''; //satırı tutmak için boş bir string oluşturuyoruz
      for (int x = 0; x < grid.width; x++) {
        //x ekseninde döngüye giriyoruz
        Node node = grid.getNode(x, y); //düğümü alıyoruz
        if (node == start) {
          //başlangıç düğümü ise
          row += 'S ';
        } else if (node == goal) {
          //hedef düğümü ise
          row += 'G ';
        } else if (node.isWall) {
          //duvar ise
          row += '| ';
        } else if (path.contains(node)) {
          //yolun bir parçası ise
          row += '* ';
        } else {
          //diğer durumlarda
          row += '. ';
        }
      }
      print(row); //satırı yazdırıyoruz
    }
  }

  int calculatePathCost(List<Node> path) {
    //yolun maliyetini hesaplıyoruz
    int cost = 0;
    for (var node in path) {
      cost += node.g; //yoldaki her düğümün g değerini topluyoruz
    }
    return cost;
  }

  //f(n) değerini yazdırma
  void printFCost(List<Node> openSet) {
    print(
        'Yolun maliyeti: ${calculatePathCost(openSet)}'); // Yolun maliyetini yazdır
  }
}
