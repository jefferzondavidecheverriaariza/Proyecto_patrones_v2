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
  final void Function(Producto) onAddToCart;

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

  final categorias = const [
    'Todos',
    'Hamburguesas',
    'Saludable',
    'Comida rápida',
  ];

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  List<Restaurante> get filtrados {
    final consulta = buscadorController.text.toLowerCase();
    return widget.restaurantes.where((restaurante) {
      final coincideBusqueda =
          restaurante.nombre.toLowerCase().contains(consulta) ||
          restaurante.categoria.toLowerCase().contains(consulta);
      final coincideCategoria =
          categoriaSeleccionada == 'Todos' ||
          restaurante.categoria == categoriaSeleccionada;
      return coincideBusqueda && coincideCategoria;
    }).toList();
  }

  IconData icono(String categoria) {
    if (categoria == 'Saludable') return Icons.eco_rounded;
    if (categoria == 'Comida rápida') return Icons.local_pizza_rounded;
    return Icons.lunch_dining_rounded;
  }

  Color color(String categoria) {
    if (categoria == 'Saludable') return const Color(0xFF319B70);
    if (categoria == 'Comida rápida') return const Color(0xFFE99A36);
    return const Color(0xFFFF6B35);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final esAmplio = constraints.maxWidth >= 850;
        final columnas = constraints.maxWidth >= 1150
            ? 3
            : constraints.maxWidth >= 650
            ? 2
            : 1;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                esAmplio ? 32 : 18,
                26,
                esAmplio ? 32 : 18,
                36,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, ${widget.usuario}',
                            style: TextStyle(
                              fontSize: esAmplio ? 30 : 25,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF20232A),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '¿Qué se te antoja hoy?',
                            style: TextStyle(
                              color: Color(0xFF777D87),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE9E1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delivery_dining,
                        color: Color(0xFFFF6B35),
                        size: 27,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF784C), Color(0xFFE94D2D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tu comida favorita,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'a un clic de distancia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pide fácil. Disfruta más.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton.tonal(
                              onPressed: () {
                                setState(() => categoriaSeleccionada = 'Todos');
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFE94D2D),
                              ),
                              child: const Text('Explorar restaurantes'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.delivery_dining_rounded,
                        color: Colors.white,
                        size: esAmplio ? 92 : 66,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: buscadorController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Buscar restaurantes o categorías',
                    prefixIcon: Icon(Icons.search_rounded),
                    suffixIcon: Icon(Icons.tune_rounded),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Explora por categoría',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categorias.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 9),
                    itemBuilder: (context, index) {
                      final categoria = categorias[index];
                      final seleccionada = categoria == categoriaSeleccionada;
                      return ChoiceChip(
                        label: Text(categoria),
                        selected: seleccionada,
                        onSelected: (_) {
                          setState(() => categoriaSeleccionada = categoria);
                        },
                        selectedColor: const Color(0xFFFFE5DC),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: seleccionada
                              ? const Color(0xFFFFB69E)
                              : const Color(0xFFE8E9ED),
                        ),
                        labelStyle: TextStyle(
                          color: seleccionada
                              ? const Color(0xFFE85C36)
                              : const Color(0xFF555B65),
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Restaurantes destacados',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      '${filtrados.length} lugares',
                      style: const TextStyle(
                        color: Color(0xFF858A93),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (filtrados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No encontramos restaurantes con esa búsqueda.',
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtrados.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: esAmplio ? 235 : 210,
                    ),
                    itemBuilder: (context, index) {
                      final restaurante = filtrados[index];
                      final colorRestaurante = color(restaurante.categoria);
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RestaurantScreen(
                                  restaurante: restaurante,
                                  carrito: widget.carrito,
                                  onAddToCart: widget.onAddToCart,
                                  onOpenCart: widget.onOpenCart,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFEDEEF1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 58,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: colorRestaurante.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: Icon(
                                        icono(restaurante.categoria),
                                        color: colorRestaurante,
                                        size: 31,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFFFFB547),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  restaurante.nombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  restaurante.descripcion,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF858A93),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 16,
                                      color: colorRestaurante,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      restaurante.tiempoEntrega,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      'Ver menú',
                                      style: TextStyle(
                                        color: Color(0xFFE85C36),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: Color(0xFFE85C36),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
