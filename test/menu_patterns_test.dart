import 'package:flutter_test/flutter_test.dart';
import 'package:queuego/patterns/creational/abstract_factory/menu_caribe_factory.dart';
import 'package:queuego/patterns/creational/abstract_factory/menu_saludable_factory.dart';
import 'package:queuego/patterns/creational/abstract_factory/menu_tradicional_factory.dart';
import 'package:queuego/patterns/structural/decorator/tipo_extra.dart';

void main() {
  group('Abstract Factory de menús', () {
    test('cada familia entrega sus combos y opciones de bebida', () {
      final tradicional = MenuTradicionalFactory();
      final caribe = MenuCaribeFactory();
      final saludable = MenuSaludableFactory();

      expect(tradicional.crearCombos().map((combo) => combo.id), [
        'combo-clasico',
        'combo-bbq',
      ]);
      expect(caribe.crearCombos().map((combo) => combo.id), [
        'combo-caribeno',
        'combo-costa',
      ]);
      expect(saludable.crearCombos().map((combo) => combo.id), [
        'combo-verde',
        'combo-ligero',
      ]);
      for (final factory in [tradicional, caribe, saludable]) {
        final nombresPlatos = factory.crearPlatos().map(
          (plato) => plato.nombre,
        );
        for (final combo in factory.crearCombos()) {
          expect(
            nombresPlatos,
            contains(combo.platoIncluido),
            reason: '${combo.nombre} debe referenciar un plato de su familia',
          );
        }
      }
      expect(
        tradicional.crearOpcionesBebida().map((opcion) => opcion.nombre),
        contains('Postobón Manzana'),
      );
      expect(
        caribe
            .crearOpcionesBebida()
            .firstWhere((opcion) => opcion.nombre == 'Jugo de mango')
            .costoAdicional,
        1000,
      );
    });
  });

  group('Decorator de extras', () {
    test('ofrece extras según menú y plato y decora el precio', () {
      final extras = TipoExtra.disponiblesPara(
        tipoMenu: 'caribe',
        nombrePlato: 'Patacones con carne',
      );
      final base = MenuCaribeFactory().crearPlatos().firstWhere(
        (plato) => plato.nombre == 'Patacones con carne',
      );
      final decorado = PlatoPersonalizador.aplicar(base, extras);

      expect(extras.map((extra) => extra.etiqueta), [
        'Queso costeño',
        'Suero costeño',
        'Carne adicional',
      ]);
      expect(decorado.precio, 31000);
      expect(decorado.nombre, contains('Queso costeño'));
    });

    test('no ofrece extras para bebidas ni empaques como ingrediente', () {
      expect(
        TipoExtra.disponiblesPara(
          tipoMenu: 'caribe',
          nombrePlato: 'Arepa de huevo',
        ),
        isEmpty,
      );
      expect(
        TipoExtra.disponiblesPara(
          tipoMenu: 'tradicional',
          nombrePlato: 'Hamburguesa clásica',
        ).map((extra) => extra.etiqueta),
        isNot(contains('Empaque ecológico')),
      );
    });
  });
}
