class Node {
  int x, y;  //düğümün x ve y koordinatları
  bool isWall = false; //düğümün duvar olup olmadığını belirtir
  Node? parent; //önceki düğümü tutar
  int g = 0, h = 0; // g ve h değerleri

  Node(this.x, this.y); //x ve y koordinatlarını alır

  int get f => g + h; // f(n) = g(n) + h(n)

@override
bool operator ==(Object other) { //karşılaştırma işlemi yapılıyor 
  if (other is Node) {
    return x == other.x && y == other.y; //eğer x ve y koordinatları eşitse true döner ve eşitlik vardır yani bu konumda başka bir düğüm vardır
  }
  return false; //eğer diğer düğüm değilse false döner ve eşitlik yoktur yani bu konumda başka bir düğüm yoktur
}

@override
int get hashCode {//her noktaya benzersiz bir değer atanır. her konum için farklı bir hashCode döner
  return x.hashCode ^ y.hashCode; //x ve y koordinatlarının hashCode larını birleştirir
}

}