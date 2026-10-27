import '../../creational/abstract_factory/plato.dart';
import 'plato_decorator.dart';

abstract class ExtraPlatoDecorator extends PlatoDecorator {
  final String etiqueta;
  final double costoExtra;

  const ExtraPlatoDecorator(super.plato, this.etiqueta, this.costoExtra);

  @override
  String get nombre => '${super.nombre} + $etiqueta';

  @override
  double get precio => super.precio + costoExtra;
}

class QuesoExtraDecorator extends ExtraPlatoDecorator {
  static const double costo = 3000;

  const QuesoExtraDecorator(Plato plato) : super(plato, 'Queso extra', costo);
}

class TocinetaExtraDecorator extends ExtraPlatoDecorator {
  static const double costo = 4500;

  const TocinetaExtraDecorator(Plato plato) : super(plato, 'Tocineta', costo);
}

class TocinetaPapasDecorator extends ExtraPlatoDecorator {
  static const double costo = 3500;

  const TocinetaPapasDecorator(Plato plato) : super(plato, 'Tocineta', costo);
}

class SalsaEspecialDecorator extends ExtraPlatoDecorator {
  static const double costo = 1500;

  const SalsaEspecialDecorator(Plato plato)
    : super(plato, 'Salsa especial', costo);
}

class CarneHamburguesaDecorator extends ExtraPlatoDecorator {
  static const double costo = 7000;

  const CarneHamburguesaDecorator(Plato plato)
    : super(plato, 'Carne adicional', costo);
}

class QuesoCheddarDecorator extends ExtraPlatoDecorator {
  static const double costo = 2500;

  const QuesoCheddarDecorator(Plato plato)
    : super(plato, 'Queso cheddar', costo);
}

class QuesoCostenoDecorator extends ExtraPlatoDecorator {
  static const double costo = 3000;

  const QuesoCostenoDecorator(Plato plato)
    : super(plato, 'Queso costeño', costo);
}

class SueroCostenoDecorator extends ExtraPlatoDecorator {
  static const double costo = 2000;

  const SueroCostenoDecorator(Plato plato)
    : super(plato, 'Suero costeño', costo);
}

class CarnePataconesDecorator extends ExtraPlatoDecorator {
  static const double costo = 6000;

  const CarnePataconesDecorator(Plato plato)
    : super(plato, 'Carne adicional', costo);
}

class AguacateDecorator extends ExtraPlatoDecorator {
  static const double costo = 2500;

  const AguacateDecorator(Plato plato) : super(plato, 'Aguacate', costo);
}

class PolloAdicionalDecorator extends ExtraPlatoDecorator {
  static const double costo = 5000;

  const PolloAdicionalDecorator(Plato plato)
    : super(plato, 'Pollo adicional', costo);
}

class AderezoDecorator extends ExtraPlatoDecorator {
  static const double costo = 1500;

  const AderezoDecorator(Plato plato) : super(plato, 'Aderezo', costo);
}

class EmpaqueEcologicoDecorator extends ExtraPlatoDecorator {
  static const double costo = 1000;

  const EmpaqueEcologicoDecorator(Plato plato)
    : super(plato, 'Empaque ecológico', costo);
}
