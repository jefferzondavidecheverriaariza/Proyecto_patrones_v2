import 'bebida.dart';
import 'combo_menu.dart';
import 'opcion_bebida.dart';
import 'plato.dart';

abstract class MenuFactory {
  // =====================================================
  // ABSTRACT FACTORY
  //
  // Define la creación de una familia de productos
  // relacionados: varios platos y una bebida.
  // =====================================================

  List<Plato> crearPlatos();

  Bebida crearBebida();

  List<OpcionBebida> crearOpcionesBebida();

  List<ComboMenu> crearCombos();
}
