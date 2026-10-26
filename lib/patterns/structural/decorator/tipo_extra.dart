import '../../creational/abstract_factory/plato.dart';
import 'extras_decorators.dart';

// =====================================================
// DECORATOR - CATÁLOGO DE EXTRAS
//
// Relaciona cada extra disponible con su decorador.
// Agregar un extra nuevo = una entrada aquí + un
// ConcreteDecorator. Nada más cambia (OCP).
// =====================================================
enum TipoExtra {
  quesoExtra('Queso extra', QuesoExtraDecorator.costo, QuesoExtraDecorator.new),
  tocineta(
    'Tocineta',
    TocinetaExtraDecorator.costo,
    TocinetaExtraDecorator.new,
  ),
  salsaEspecial(
    'Salsa especial',
    SalsaEspecialDecorator.costo,
    SalsaEspecialDecorator.new,
  ),
  empaqueEcologico(
    'Empaque ecológico',
    EmpaqueEcologicoDecorator.costo,
    EmpaqueEcologicoDecorator.new,
  );

  final String etiqueta;
  final double costo;
  final Plato Function(Plato) _crear;

  const TipoExtra(this.etiqueta, this.costo, this._crear);

  Plato decorar(Plato plato) => _crear(plato);
}

// =====================================================
// Aplica los extras elegidos en orden determinista,
// para que la misma selección siempre produzca el
// mismo nombre (y por tanto el mismo id en el carrito).
// =====================================================
class PlatoPersonalizador {
  const PlatoPersonalizador._();

  static Plato aplicar(Plato base, Iterable<TipoExtra> extras) {
    final ordenados = extras.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return ordenados.fold<Plato>(base, (plato, extra) => extra.decorar(plato));
  }
}
