import '../../creational/abstract_factory/plato.dart';

// =====================================================
// DECORATOR - DECORATOR (clase base)
//
// Implementa Plato y mantiene una referencia al Plato
// envuelto. Por defecto delega todo en el componente.
// =====================================================
abstract class PlatoDecorator implements Plato {
  final Plato plato;

  const PlatoDecorator(this.plato);

  @override
  String get nombre => plato.nombre;

  @override
  double get precio => plato.precio;
}
