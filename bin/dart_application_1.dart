import 'dart:math';
import '../bin/grid.dart';
import '../bin/node.dart';
import '../bin/problem.dart';

void main() {
  int width = 16, height = 16; //grid boyutları
  var grid = Grid(width, height); //grid oluştur

  var random = Random();
  //başlangıç ve hedef noktalarını rastgele belirlemek istediğimiz için tanımladığımız anda değer atamak yerine sonrs
  Node start, goal;

  do {
    int startX = random.nextInt(width); //0 ile width arasında rastgele bir x koordinatı belirler
    int startY = random.nextInt(height); //0 ile height arasında rastgele bir y koordinatı belirler
    start = grid.getNode(startX, startY); //başlangıç düğümü
  } while (start.isWall); //başlangıç noktasını duvar olmayan bir yerden seçmek için karşılaştırma yapar

  do {
    int goalX = random.nextInt(width); //0 ile width arasında rastgele bir x koordinatı belirler
    int goalY = random.nextInt(height); //0 ile height arasında rastgele bir y koordinatı belirler
    goal = grid.getNode(goalX, goalY); //hedef düğümü rastgele seçilen x ve y koordinatları ile oluşur
  } while (goal.isWall || goal == start); //hedef noktasını duvar olmayan bir yerden ve başlangıç noktasından farklı seçmek için karşılaştırma yapar

  //duvar olmayan bir konum bulunduğunda başlangıç ve hedef noktalarını gride ekler
  grid.setStart(start.x, start.y);
  grid.setGoal(goal.x, goal.y);

  var problem = Problem(grid, start, goal); //problem nesnesi oluşturur
  //grid üzerindeki duvarları rastgele ekler
  problem.addWallSafe(grid, (width * height * 0.3).toInt(), start, goal);//%30 duvar ekler
  //başlangıç ve hedef noktaları arasındaki yolu bulmak için A* algoritmasını uygular

  //yol bulunmaya çalışılır
  var path = problem.aStar();

  //yol bulunamadıysa
  if (path.isEmpty) {
    print("Yol bulunamadı!");
  }

  //yol bulunsa da bulunamasa da harita yazdırılır bu şekilde harita incelenip neden yol bulunamadığı anlaşılabilir
  problem.printPath(path);

  // Başlangıç ve hedef noktaları arasındaki maliyet hesaplanır
  // ve ekrana yazdırılır
  problem.printFCost(
      [grid.start!, grid.goal!]); //openset içerisine buradaki noktalar eklenr sonrasında maliyet hesaplanır
}