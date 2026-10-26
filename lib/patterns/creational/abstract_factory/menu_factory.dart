import 'bebida.dart';
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
}