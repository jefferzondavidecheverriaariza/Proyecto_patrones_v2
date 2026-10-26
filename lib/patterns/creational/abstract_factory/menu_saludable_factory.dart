import 'bebida.dart';
import 'ensalada.dart';
import 'jugo_natural.dart';
import 'menu_factory.dart';
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
