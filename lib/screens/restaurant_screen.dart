import 'package:flutter/material.dart';

import '../models/carrito_item.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';

import '../patterns/abstract_factory/menu_factory.dart';
import '../patterns/abstract_factory/menu_caribe_factory.dart';
import '../patterns/abstract_factory/menu_saludable_factory.dart';
import '../patterns/abstract_factory/menu_tradicional_factory.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurante restaurante;

  final List<CarritoItem> carrito;

  final void Function(Producto producto) onAddToCart;

  final VoidCallback onOpenCart;

  const RestaurantScreen({
    super.key,
    required this.restaurante,
    required this.carrito,
    required this.onAddToCart,
    required this.onOpenCart,
  });

  // =====================================================
  // ABSTRACT FACTORY
  //
  // Seleccionamos la fábrica correspondiente al
  // restaurante.
  // =====================================================

  MenuFactory obtenerFactory() {
    switch (restaurante.tipoMenu) {
      case 'caribe':
        return MenuCaribeFactory();

      case 'saludable':
        return MenuSaludableFactory();

      default:
        return MenuTradicionalFactory();
    }
  }

  // =====================================================
  // PRODUCTOS DEL RESTAURANTE
  // =====================================================

  List<Producto> obtenerProductos() {
    final factory = obtenerFactory();

    final platos = factory.crearPlatos();
    final bebida = factory.crearBebida();

    final productos = <Producto>[];

    for (final plato in platos) {
      productos.add(
        Producto(
          id: '${restaurante.id}-${plato.nombre}',
          nombre: plato.nombre,
          precio: plato.precio,
          descripcion: 'Preparado especialmente para ti.',
          categoria: 'Plato',
        ),
      );
    }

    productos.add(
      Producto(
        id: '${restaurante.id}-${bebida.nombre}',
        nombre: bebida.nombre,
        precio: bebida.precio,
        descripcion: 'Bebida para acompañar tu pedido.',
        categoria: 'Bebida',
      ),
    );

    return productos;
  }

  // =====================================================
  // ICONOS
  // =====================================================

  IconData obtenerIcono(Producto producto) {
    if (producto.categoria == 'Bebida') {
      return Icons.local_drink_outlined;
    }

    switch (restaurante.tipoMenu) {
      case 'caribe':
        return Icons.restaurant_outlined;

      case 'saludable':
        return Icons.eco_outlined;

      default:
        return Icons.fastfood_outlined;
    }
  }

  // =====================================================
  // CANTIDAD DEL CARRITO
  // =====================================================

  int get cantidadCarrito {
    return carrito.fold(0, (total, item) => total + item.cantidad);
  }

  // =====================================================
  // TOTAL DEL CARRITO
  // =====================================================

  double get totalCarrito {
    return carrito.fold(0, (total, item) => total + item.subtotal);
  }

  // =====================================================
  // INTERFAZ
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final productos = obtenerProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurante.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          // =================================================
          // ENCABEZADO
          // =================================================
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange.shade400,
                  Colors.deepOrange.shade700,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Icon(Icons.restaurant, size: 70, color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            restaurante.nombre,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            restaurante.descripcion,
            style: const TextStyle(color: Colors.grey, fontSize: 15),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.schedule, size: 18),

              const SizedBox(width: 5),

              Text(restaurante.tiempoEntrega),

              const SizedBox(width: 15),

              const Icon(Icons.star, color: Colors.amber, size: 18),

              const SizedBox(width: 5),

              const Text('4.8'),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Menú',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // =================================================
          // PRODUCTOS
          // =================================================
          ...productos.map((producto) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Icon(
                        obtenerIcono(producto),
                        color: Colors.deepOrange,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            producto.descripcion,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            '\$${producto.precio.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        onAddToCart(producto);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${producto.nombre} agregado al carrito',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },

                      style: IconButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                      ),

                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),

      // =====================================================
      // CARRITO FLOTANTE
      // =====================================================
      floatingActionButton: cantidadCarrito > 0
          ? FloatingActionButton.extended(
              onPressed: onOpenCart,

              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,

              icon: Badge(
                label: Text('$cantidadCarrito'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),

              label: Text(
                'Ver carrito · \$${totalCarrito.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
