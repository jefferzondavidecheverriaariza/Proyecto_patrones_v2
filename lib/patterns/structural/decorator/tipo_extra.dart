import '../../creational/abstract_factory/plato.dart';
import 'extras_decorators.dart';

enum TipoExtra {
  quesoExtra(
    'Queso extra',
    QuesoExtraDecorator.costo,
    QuesoExtraDecorator.new,
    'tradicional',
    'hamburguesa',
  ),
  tocinetaHamburguesa(
    'Tocineta',
    TocinetaExtraDecorator.costo,
    TocinetaExtraDecorator.new,
    'tradicional',
    'hamburguesa',
  ),
  salsaEspecial(
    'Salsa especial',
    SalsaEspecialDecorator.costo,
    SalsaEspecialDecorator.new,
    'tradicional',
    'hamburguesa',
  ),
  carneHamburguesa(
    'Carne adicional',
    CarneHamburguesaDecorator.costo,
    CarneHamburguesaDecorator.new,
    'tradicional',
    'hamburguesa',
  ),
  quesoCheddar(
    'Queso cheddar',
    QuesoCheddarDecorator.costo,
    QuesoCheddarDecorator.new,
    'tradicional',
    'papas',
  ),
  tocinetaPapas(
    'Tocineta',
    TocinetaPapasDecorator.costo,
    TocinetaPapasDecorator.new,
    'tradicional',
    'papas',
  ),
  salsaPapas(
    'Salsa especial',
    SalsaEspecialDecorator.costo,
    SalsaEspecialDecorator.new,
    'tradicional',
    'papas',
  ),
  quesoCosteno(
    'Queso costeño',
    QuesoCostenoDecorator.costo,
    QuesoCostenoDecorator.new,
    'caribe',
    'patacones',
  ),
  sueroCosteno(
    'Suero costeño',
    SueroCostenoDecorator.costo,
    SueroCostenoDecorator.new,
    'caribe',
    'patacones',
  ),
  carnePatacones(
    'Carne adicional',
    CarnePataconesDecorator.costo,
    CarnePataconesDecorator.new,
    'caribe',
    'patacones',
  ),
  aguacate(
    'Aguacate',
    AguacateDecorator.costo,
    AguacateDecorator.new,
    'saludable',
    '',
  ),
  polloAdicional(
    'Pollo adicional',
    PolloAdicionalDecorator.costo,
    PolloAdicionalDecorator.new,
    'saludable',
    '',
  ),
  aderezo(
    'Aderezo',
    AderezoDecorator.costo,
    AderezoDecorator.new,
    'saludable',
    '',
  ),
  empaqueEcologico(
    'Empaque ecológico',
    EmpaqueEcologicoDecorator.costo,
    EmpaqueEcologicoDecorator.new,
    '',
    '',
    visibleEnMenu: false,
  );

  final String etiqueta;
  final double costo;
  final Plato Function(Plato) _crear;
  final String tipoMenu;
  final String nombrePlato;
  final bool visibleEnMenu;

  const TipoExtra(
    this.etiqueta,
    this.costo,
    this._crear,
    this.tipoMenu,
    this.nombrePlato, {
    this.visibleEnMenu = true,
  });

  Plato decorar(Plato plato) => _crear(plato);

  static List<TipoExtra> disponiblesPara({
    required String tipoMenu,
    required String nombrePlato,
  }) {
    final menu = tipoMenu.toLowerCase();
    final plato = nombrePlato.toLowerCase();
    return TipoExtra.values
        .where(
          (extra) =>
              extra.visibleEnMenu &&
              extra.tipoMenu == menu &&
              (extra.nombrePlato.isEmpty || plato.contains(extra.nombrePlato)),
        )
        .toList(growable: false);
  }
}

class PlatoPersonalizador {
  const PlatoPersonalizador._();

  static Plato aplicar(Plato base, Iterable<TipoExtra> extras) {
    final ordenados = extras.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return ordenados.fold<Plato>(base, (plato, extra) => extra.decorar(plato));
  }
}
