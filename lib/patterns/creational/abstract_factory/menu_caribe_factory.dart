import 'bebida.dart';
import 'menu_factory.dart';
import 'plato.dart';

class MenuCaribeFactory implements MenuFactory {
  // =====================================================
  // ABSTRACT FACTORY - CONCRETE FACTORY
  //
  // Familia de productos de comida caribeña.
  // =====================================================

  @override
  List<Plato> crearPlatos() {
    return [ArepaDeHuevo(), PataconesConCarne(), Carimanolas()];
  }

  @override
  Bebida crearBebida() {
    return JugoCorozo();
  }
}

// =====================================================
// PRODUCTOS CONCRETOS DEL MENÚ CARIBE
// =====================================================

class ArepaDeHuevo implements Plato {
  @override
  String get nombre => 'Arepa de huevo';

  @override
  double get precio => 9000;
}

class PataconesConCarne implements Plato {
  @override
  String get nombre => 'Patacones con carne';

  @override
  double get precio => 20000;
}

class Carimanolas implements Plato {
  @override
  String get nombre => 'Carimañolas';

  @override
  double get precio => 8000;
}

class JugoCorozo implements Bebida {
  @override
  String get nombre => 'Jugo de corozo';

  @override
  double get precio => 7000;
}
