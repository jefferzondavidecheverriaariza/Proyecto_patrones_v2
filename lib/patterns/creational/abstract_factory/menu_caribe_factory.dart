import 'bebida.dart';
import 'combo_menu.dart';
import 'menu_factory.dart';
import 'opcion_bebida.dart';
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

  @override
  List<OpcionBebida> crearOpcionesBebida() => const [
    OpcionBebida(nombre: 'Jugo de corozo'),
    OpcionBebida(nombre: 'Jugo de mango', costoAdicional: 1000),
    OpcionBebida(nombre: 'Limonada'),
    OpcionBebida(nombre: 'Agua'),
  ];

  @override
  List<ComboMenu> crearCombos() => const [
    ComboMenu(
      id: 'combo-caribeno',
      nombre: 'Combo Caribeño',
      descripcion: 'Patacones con carne + bebida',
      precio: 25000,
      platoIncluido: 'Patacones con carne',
    ),
    ComboMenu(
      id: 'combo-costa',
      nombre: 'Combo de la costa',
      descripcion: 'Arepa de huevo + bebida',
      precio: 13000,
      platoIncluido: 'Arepa de huevo',
    ),
  ];
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
