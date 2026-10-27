import 'package:flutter/material.dart';

import '../models/carrito_item.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';
import '../patterns/creational/abstract_factory/menu_factory.dart';
import '../patterns/creational/abstract_factory/combo_menu.dart';
import '../patterns/creational/abstract_factory/menu_factory_resolver.dart';
import '../patterns/creational/abstract_factory/opcion_bebida.dart';
import '../patterns/structural/adapter/plato_producto_adapter.dart';
import '../patterns/structural/decorator/tipo_extra.dart';

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

  MenuFactory obtenerFactory() =>
      MenuFactoryResolver.para(restaurante.tipoMenu);

  List<Producto> obtenerProductos() {
    final factory = obtenerFactory();
    final productos = <Producto>[];
    for (final plato in factory.crearPlatos()) {
      productos.add(
        PlatoProductoAdapter(
          plato,
          restauranteId: restaurante.id,
          descripcion: _descripcionProducto(plato.nombre),
        ),
      );
    }
    final bebida = factory.crearBebida();
    productos.add(
      Producto(
        id: '${restaurante.id}-${bebida.nombre}',
        nombre: bebida.nombre,
        precio: bebida.precio,
        descripcion: 'Escoge la presentación o el sabor disponible.',
        categoria: 'Bebida',
      ),
    );
    return productos;
  }

  String _descripcionProducto(String nombre) {
    if (nombre.toLowerCase().contains('arepa de huevo')) {
      return 'Arepa de huevo tradicional. Se agrega directamente, sin extras.';
    }
    if (nombre.toLowerCase().contains('hamburguesa')) {
      return 'Preparada al momento. Personaliza los ingredientes si deseas.';
    }
    if (restaurante.tipoMenu == 'caribe') {
      return 'Sabor tradicional de la región Caribe.';
    }
    if (restaurante.tipoMenu == 'saludable') {
      return 'Una opción fresca y balanceada.';
    }
    return 'Preparado al momento para tu pedido.';
  }

  int get cantidadCarrito =>
      carrito.fold(0, (total, item) => total + item.cantidad);
  double get totalCarrito =>
      carrito.fold(0, (total, item) => total + item.subtotal);

  IconData obtenerIcono(Producto producto) {
    if (producto.categoria == 'Bebida') return Icons.local_drink_outlined;
    if (restaurante.tipoMenu == 'saludable') return Icons.eco_outlined;
    if (restaurante.tipoMenu == 'caribe') return Icons.restaurant_outlined;
    return Icons.fastfood_outlined;
  }

  Future<void> _configurarProducto(
    BuildContext context,
    Producto producto,
  ) async {
    final extras = TipoExtra.disponiblesPara(
      tipoMenu: restaurante.tipoMenu,
      nombrePlato: producto.nombre,
    );
    final esBebida = producto.categoria == 'Bebida';
    if (!esBebida && extras.isEmpty) {
      onAddToCart(producto);
      _mensaje(context, '${producto.nombre} agregado al carrito');
      return;
    }

    final factory = obtenerFactory();
    final sabores = esBebida
        ? factory.crearOpcionesBebida()
        : const <OpcionBebida>[];
    String? sabor = sabores.isNotEmpty ? sabores.first.nombre : null;
    final seleccionados = <TipoExtra>{};
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final precioSabor = sabores
              .where((e) => e.nombre == sabor)
              .fold<double>(
                0,
                (total, opcion) => total + opcion.costoAdicional,
              );
          final platoDecorado = producto is PlatoProductoAdapter
              ? PlatoPersonalizador.aplicar(producto.plato, seleccionados)
              : null;
          final precioPersonalizado =
              (platoDecorado?.precio ?? producto.precio) + precioSabor;
          final extrasOrdenados = seleccionados.toList()
            ..sort((a, b) => a.index.compareTo(b.index));
          return AlertDialog(
            title: Text(
              esBebida ? 'Elige tu bebida' : 'Personaliza ${producto.nombre}',
            ),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (esBebida) ...[
                      const Text(
                        'Sabor o tipo de bebida',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: sabor,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Selecciona una opción',
                        ),
                        items: sabores
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.nombre,
                                child: Text(e.nombre),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setDialogState(() => sabor = value),
                      ),
                    ] else ...[
                      const Text(
                        'Extras disponibles',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      ...extras.map(
                        (extra) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: seleccionados.contains(extra),
                          title: Text(extra.etiqueta),
                          subtitle: Text(
                            '+\$${extra.costo.toStringAsFixed(0)}',
                          ),
                          onChanged: (value) => setDialogState(() {
                            if (value == true) {
                              seleccionados.add(extra);
                            } else {
                              seleccionados.remove(extra);
                            }
                          }),
                        ),
                      ),
                    ],
                    const Divider(),
                    Text(
                      'Total: \$${precioPersonalizado.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  if (esBebida && sabor == null) return;
                  final detalle = esBebida
                      ? 'Variante: $sabor'
                      : (seleccionados.isEmpty
                            ? 'Sin extras'
                            : 'Extras: ${extrasOrdenados.map((extra) => extra.etiqueta).join(', ')}');
                  final nombre = esBebida
                      ? '$sabor'
                      : (platoDecorado?.nombre ?? producto.nombre);
                  final opcionesId = <String>[
                    ...extrasOrdenados.map((extra) => extra.name),
                    if (esBebida && sabor != null) sabor!,
                  ]..sort();
                  final personalizado = Producto(
                    id: '${producto.id}-${opcionesId.join('-')}',
                    nombre: nombre,
                    precio: precioPersonalizado,
                    descripcion: producto.descripcion,
                    categoria: producto.categoria,
                    detalle: detalle,
                  );
                  onAddToCart(personalizado);
                  Navigator.pop(dialogContext);
                  _mensaje(context, '$nombre agregado al carrito');
                },
                child: const Text('Agregar al carrito'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _agregarCombo(BuildContext context, ComboMenu combo) async {
    final factory = obtenerFactory();
    final bebidas = factory.crearOpcionesBebida();
    String bebida = bebidas.first.nombre;
    final platoBase = factory.crearPlatos().firstWhere(
      (plato) => plato.nombre == combo.platoIncluido,
    );
    final extras = TipoExtra.disponiblesPara(
      tipoMenu: restaurante.tipoMenu,
      nombrePlato: combo.platoIncluido,
    );
    final seleccionados = <TipoExtra>{};
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final platoPersonalizado = PlatoPersonalizador.aplicar(
            platoBase,
            seleccionados,
          );
          final adicionales = platoPersonalizado.precio - platoBase.precio;
          final costoBebida = bebidas
              .where((opcion) => opcion.nombre == bebida)
              .fold<double>(
                0,
                (total, opcion) => total + opcion.costoAdicional,
              );
          final extrasOrdenados = seleccionados.toList()
            ..sort((a, b) => a.index.compareTo(b.index));
          return AlertDialog(
            title: Text(combo.nombre),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(combo.descripcion),
                    const SizedBox(height: 16),
                    const Text(
                      'Escoge la bebida del combo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: bebida,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: bebidas
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.nombre,
                              child: Text(e.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setDialogState(() {
                        if (value != null) bebida = value;
                      }),
                    ),
                    if (extras.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Personaliza tu plato',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...extras.map(
                        (extra) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: seleccionados.contains(extra),
                          title: Text(extra.etiqueta),
                          subtitle: Text(
                            '+\$${extra.costo.toStringAsFixed(0)}',
                          ),
                          onChanged: (value) => setDialogState(() {
                            if (value == true) {
                              seleccionados.add(extra);
                            } else {
                              seleccionados.remove(extra);
                            }
                          }),
                        ),
                      ),
                    ],
                    const Divider(),
                    Text(
                      'Total: \$${(combo.precio + adicionales + costoBebida).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  final detalle =
                      'Incluye papas/acompañamiento y $bebida${extrasOrdenados.isEmpty ? '' : ' · Extras: ${extrasOrdenados.map((extra) => extra.etiqueta).join(', ')}'}';
                  onAddToCart(
                    Producto(
                      id: '${restaurante.id}-${combo.id}-${bebida.toLowerCase().replaceAll(' ', '-')}-${extrasOrdenados.map((extra) => extra.name).join('-')}',
                      nombre: combo.nombre,
                      precio: combo.precio + adicionales + costoBebida,
                      descripcion: combo.descripcion,
                      categoria: 'Combo',
                      detalle: detalle,
                    ),
                  );
                  Navigator.pop(dialogContext);
                  _mensaje(context, '${combo.nombre} agregado al carrito');
                },
                child: const Text('Agregar combo'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final factory = obtenerFactory();
    final productos = obtenerProductos();
    final combos = factory.crearCombos();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurante.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade400,
                      Colors.deepOrange.shade800,
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
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                restaurante.descripcion,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
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
              const SizedBox(height: 28),
              const Text(
                'Combos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 800 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: combos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 150,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final combo = combos[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.lunch_dining,
                                  color: Colors.deepOrange,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      combo.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      combo.descripcion,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      '\$${combo.precio.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _agregarCombo(context, combo),
                                icon: const Icon(Icons.add_circle),
                                color: Colors.deepOrange,
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Menú',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 900 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: productos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 142,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      final tieneOpciones =
                          producto.categoria == 'Bebida' ||
                          TipoExtra.disponiblesPara(
                            tipoMenu: restaurante.tipoMenu,
                            nombrePlato: producto.nombre,
                          ).isNotEmpty;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  obtenerIcono(producto),
                                  color: Colors.deepOrange,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      producto.descripcion,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${producto.precio.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _configurarProducto(context, producto),
                                icon: const Icon(Icons.add_circle),
                                color: Colors.deepOrange,
                                iconSize: 30,
                                tooltip: tieneOpciones
                                    ? 'Personalizar'
                                    : 'Agregar',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
