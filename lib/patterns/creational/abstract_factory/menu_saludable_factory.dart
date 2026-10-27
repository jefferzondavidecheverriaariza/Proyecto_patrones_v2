import 'bebida.dart';
import 'combo_menu.dart';
import 'ensalada.dart';
import 'jugo_natural.dart';
import 'menu_factory.dart';
import 'opcion_bebida.dart';
import 'plato.dart';

class MenuSaludableFactory implements MenuFactory {
  // =====================================================
  // ABSTRACT FACTORY - CONCRETE FACTORY
  //
  // Familia de productos saludables.
  // =====================================================

  @override
  List<Plato> crearPlatos() {
    return [Ensalada(), BowlPollo(), WrapVegetal()];
  }

  @override
  Bebida crearBebida() {
    return JugoNatural();
  }

  @override
  List<OpcionBebida> crearOpcionesBebida() => const [
    OpcionBebida(nombre: 'Jugo de naranja'),
    OpcionBebida(nombre: 'Jugo de mango'),
    OpcionBebida(nombre: 'Jugo verde', costoAdicional: 1000),
    OpcionBebida(nombre: 'Agua'),
  ];

  @override
  List<ComboMenu> crearCombos() => const [
    ComboMenu(
      id: 'combo-verde',
      nombre: 'Combo Verde',
      descripcion: 'Bowl de pollo + jugo natural',
      precio: 23000,
      platoIncluido: 'Bowl de pollo',
    ),
    ComboMenu(
      id: 'combo-ligero',
      nombre: 'Combo Ligero',
      descripcion: 'Wrap vegetal + bebida',
      precio: 19000,
      platoIncluido: 'Wrap vegetal',
    ),
  ];
}

// =====================================================
// PRODUCTOS CONCRETOS DEL MENÚ SALUDABLE
// =====================================================

class BowlPollo implements Plato {
  @override
  String get nombre => 'Bowl de pollo';

  @override
  double get precio => 18000;
}

class WrapVegetal implements Plato {
  @override
  String get nombre => 'Wrap vegetal';

  @override
  double get precio => 15000;
}
