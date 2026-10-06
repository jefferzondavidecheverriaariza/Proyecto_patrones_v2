class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String categoria;

  Producto({
    this.id = '',
    required this.nombre,
    required this.precio,
    this.descripcion = '',
    this.categoria = 'General',
  });
}
