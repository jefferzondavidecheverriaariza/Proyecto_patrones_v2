import 'plato_decorator.dart';

// =====================================================
// DECORATOR - CONCRETE DECORATORS
//
// Cada uno agrega una responsabilidad (nombre + costo)
// al plato que envuelve.
// =====================================================

class QuesoExtraDecorator extends PlatoDecorator {
  static const double costo = 3000;

  const QuesoExtraDecorator(super.plato);

  @override
  String get nombre => '${super.nombre} + Queso extra';

  @override
  double get precio => super.precio + costo;
}

class TocinetaExtraDecorator extends PlatoDecorator {
  static const double costo = 4500;

  const TocinetaExtraDecorator(super.plato);

  @override
  String get nombre => '${super.nombre} + Tocineta';

  @override
  double get precio => super.precio + costo;
}

class SalsaEspecialDecorator extends PlatoDecorator {
  static const double costo = 1500;

  const SalsaEspecialDecorator(super.plato);

  @override
  String get nombre => '${super.nombre} + Salsa especial';

  @override
  double get precio => super.precio + costo;
}

class EmpaqueEcologicoDecorator extends PlatoDecorator {
  static const double costo = 1000;

  const EmpaqueEcologicoDecorator(super.plato);

  @override
  String get nombre => '${super.nombre} + Empaque ecológico';

  @override
  double get precio => super.precio + costo;
}
