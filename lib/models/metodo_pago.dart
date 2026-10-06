enum TipoMetodoPago { efectivo, tarjeta, nequi }

class MetodoPago {
  final TipoMetodoPago tipo;
  final String nombre;
  final String descripcion;

  const MetodoPago({
    required this.tipo,
    required this.nombre,
    required this.descripcion,
  });

  static const efectivo = MetodoPago(
    tipo: TipoMetodoPago.efectivo,
    nombre: 'Efectivo',
    descripcion: 'Paga al recibir tu pedido',
  );

  static const tarjeta = MetodoPago(
    tipo: TipoMetodoPago.tarjeta,
    nombre: 'Tarjeta',
    descripcion: 'Pago simulado con tarjeta',
  );

  static const nequi = MetodoPago(
    tipo: TipoMetodoPago.nequi,
    nombre: 'Nequi',
    descripcion: 'Pago simulado con Nequi',
  );

  static const List<MetodoPago> disponibles = [efectivo, tarjeta, nequi];
}
