import 'package:flutter/material.dart';

import '../models/carrito_item.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Restaurante> restaurantes;
  final List<CarritoItem> carrito;
  final int cantidadCarrito;
  final String usuario;
  final VoidCallback onOpenCart;
  final void Function(Producto producto) onAddToCart;

  const HomeScreen({
    super.key,
    required this.restaurantes,
    required this.carrito,
    required this.cantidadCarrito,
    required this.usuario,
    required this.onOpenCart,
    required this.onAddToCart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final buscadorController = TextEditingController();

  String categoriaSeleccionada = 'Todos';

  final categorias = ['Todos', 'Hamburguesas', 'Saludable', 'Comida rápida'];

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  List<Restaurante> get restaurantesFiltrados {
    final texto = buscadorController.text.toLowerCase();

    return widget.restaurantes.where((restaurante) {
      final coincideTexto =
          restaurante.nombre.toLowerCase().contains(texto) ||
          restaurante.categoria.toLowerCase().contains(texto);

      final coincideCategoria =
          categoriaSeleccionada == 'Todos' ||
          restaurante.categoria == categoriaSeleccionada;

      return coincideTexto && coincideCategoria;
    }).toList();
  }

  IconData iconoRestaurante(String categoria) {
    switch (categoria) {
      case 'Saludable':
        return Icons.eco_outlined;

      case 'Comida rápida':
        return Icons.fastfood_outlined;

      default:
        return Icons.lunch_dining_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        Text(
          'Hola, ${widget.usuario}',
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        const Text(
          '¿Qué quieres pedir hoy?',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: buscadorController,
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Buscar restaurantes o comida...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categorias.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final categoria = categorias[index];

              final seleccionada = categoria == categoriaSeleccionada;

              return ChoiceChip(
                label: Text(categoria),
                selected: seleccionada,
                selectedColor: Colors.deepOrange,
                labelStyle: TextStyle(
                  color: seleccionada ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (_) {
                  setState(() {
                    categoriaSeleccionada = categoria;
                  });
                },
              );
            },
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'Restaurantes cerca de ti',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        ...restaurantesFiltrados.map((restaurante) {
          return _RestaurantCard(
            restaurante: restaurante,
            icono: iconoRestaurante(restaurante.categoria),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantScreen(
                    restaurante: restaurante,

                    // Carrito actual
                    carrito: widget.carrito,

                    // Agregar producto al carrito
                    onAddToCart: widget.onAddToCart,

                    // Abrir carrito
                    onOpenCart: widget.onOpenCart,
                  ),
                ),
              );
            },
          );
        }),

        if (restaurantesFiltrados.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('No encontramos resultados.')),
          ),
      ],
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurante restaurante;
  final IconData icono;
  final VoidCallback onTap;

  const _RestaurantCard({
    required this.restaurante,
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icono, size: 38, color: Colors.deepOrange),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurante.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      restaurante.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16),

                        const SizedBox(width: 4),

                        Text(restaurante.tiempoEntrega),

                        const SizedBox(width: 12),

                        const Icon(Icons.star, size: 16, color: Colors.amber),

                        const SizedBox(width: 3),

                        const Text('4.8'),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
