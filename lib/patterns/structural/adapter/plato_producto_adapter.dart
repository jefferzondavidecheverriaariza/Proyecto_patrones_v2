import '../../../models/producto.dart';
import '../../creational/abstract_factory/plato.dart';

// ADAPTER: convierte un Plato del menú en el Producto que usa QueueGo.
class PlatoProductoAdapter extends Producto {
  final Plato plato;

  PlatoProductoAdapter(
    Plato plato, {
    required String restauranteId,
    String? nombre,
    double? precio,
    String? descripcion,
    List<String> personalizacion = const [],
  }) : plato = plato,
       super(
         id: '$restauranteId-${nombre ?? plato.nombre}-${precio ?? plato.precio}-${personalizacion.join('-')}',
         nombre: nombre ?? plato.nombre,
         precio: precio ?? plato.precio,
         descripcion: descripcion ?? 'Preparado especialmente para ti.',
         categoria: 'Plato',
         detalle: personalizacion.join(', '),
       );
}
