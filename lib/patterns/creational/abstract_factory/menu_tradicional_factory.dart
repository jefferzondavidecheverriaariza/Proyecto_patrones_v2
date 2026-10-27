import 'bebida.dart';
import 'combo_menu.dart';
import 'gaseosa.dart';
import 'hamburguesa.dart';
import 'menu_factory.dart';
import 'opcion_bebida.dart';
import 'plato.dart';

class MenuTradicionalFactory implements MenuFactory {
  // =====================================================
  // ABSTRACT FACTORY - CONCRETE FACTORY
  //
  // Familia de productos para restaurantes
  // de comida tradicional.
  // =====================================================

  @override
  List<Plato> crearPlatos() {
    return [Hamburguesa(), HamburguesaBbq(), PapasFritas()];
  }

  @override
  Bebida crearBebida() {
    return Gaseosa();
  }

  @override
  List<OpcionBebida> crearOpcionesBebida() => const [
    OpcionBebida(nombre: 'Coca-Cola'),
    OpcionBebida(nombre: 'Postobón Manzana'),
    OpcionBebida(nombre: 'Postobón Colombiana'),
    OpcionBebida(nombre: 'Postobón Uva'),
    OpcionBebida(nombre: 'Sprite'),
    OpcionBebida(nombre: 'Agua'),
  ];

  @override
  List<ComboMenu> crearCombos() => const [
    ComboMenu(
      id: 'combo-clasico',
      nombre: 'Combo Clásico',
      descripcion: 'Hamburguesa + papas + gaseosa',
      precio: 26000,
      platoIncluido: 'Hamburguesa clásica',
    ),
    ComboMenu(
      id: 'combo-bbq',
      nombre: 'Combo BBQ',
      descripcion: 'Hamburguesa BBQ + papas + gaseosa',
      precio: 29000,
      platoIncluido: 'Hamburguesa BBQ',
    ),
  ];
}

// =====================================================
// PRODUCTOS CONCRETOS DEL MENÚ TRADICIONAL
// =====================================================

class HamburguesaBbq implements Plato {
  @override
  String get nombre => 'Hamburguesa BBQ';

  @override
  double get precio => 22000;
}

class PapasFritas implements Plato {
  @override
  String get nombre => 'Papas fritas';

  @override
  double get precio => 7000;
}
