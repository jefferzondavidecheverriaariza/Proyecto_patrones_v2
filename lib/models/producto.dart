class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String categoria;
  final String detalle;

  Producto({
    this.id = '',
    required this.nombre,
    required this.precio,
    this.descripcion = '',
    this.categoria = 'General',
    this.detalle = '',
  });
}
