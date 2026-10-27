import 'dart:async';

import 'package:flutter/material.dart';

import '../models/carrito_item.dart';
import '../models/direccion_entrega.dart';
import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';
import 'cart_screen.dart';
import 'address_book_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  final String usuario;
  final List<Restaurante> restaurantes;
  final List<CarritoItem> carrito;
  final List<Pedido> pedidos;
  final int cantidadCarrito;
  final List<DireccionEntrega> direcciones;
  final bool cargandoDirecciones;
  final String? errorDirecciones;
  final Future<void> Function() onLoadAddresses;
  final Future<List<DireccionEntrega>> Function() onReloadAddresses;
  final Future<List<DireccionEntrega>> Function(DireccionEntrega) onSaveAddress;
  final Future<List<DireccionEntrega>> Function(String) onDeleteAddress;
  final void Function(Producto) onAddToCart;
  final Pedido? Function(String, MetodoPago, String?) onCheckout;
  final void Function(Pedido) onReorder;
  final VoidCallback onLogout;

  const MainShell({
    super.key,
    required this.usuario,
    required this.restaurantes,
    required this.carrito,
    required this.pedidos,
    required this.cantidadCarrito,
    required this.direcciones,
    required this.cargandoDirecciones,
    required this.errorDirecciones,
    required this.onLoadAddresses,
    required this.onReloadAddresses,
    required this.onSaveAddress,
    required this.onDeleteAddress,
    required this.onAddToCart,
    required this.onCheckout,
    required this.onReorder,
    required this.onLogout,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int indice = 0;

  @override
  void initState() {
    super.initState();
    unawaited(widget.onLoadAddresses());
  }

  Future<List<DireccionEntrega>?> _abrirDirecciones() async {
    var direcciones = widget.direcciones;
    var errorDirecciones = widget.errorDirecciones;
    if (widget.cargandoDirecciones) {
      try {
        direcciones = await widget.onReloadAddresses();
        errorDirecciones = null;
      } on Exception {
        errorDirecciones = 'No se pudieron cargar las direcciones guardadas.';
      }
    }
    if (!mounted) return null;

    return Navigator.push<List<DireccionEntrega>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddressBookScreen(
          direcciones: direcciones,
          error: errorDirecciones,
          cargando: false,
          onSave: widget.onSaveAddress,
          onDelete: widget.onDeleteAddress,
          onRetry: widget.onReloadAddresses,
        ),
      ),
    );
  }

  Future<void> abrirCarrito() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => _crearPantallaCarrito()),
    );

    if (resultado == true && mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido confirmado correctamente.')),
      );
    }
  }

  CartScreen _crearPantallaCarrito() {
    return CartScreen(
      carrito: widget.carrito,
      direcciones: widget.direcciones,
      direccionPredeterminadaId: widget.direcciones
          .where((direccion) => direccion.esPredeterminada)
          .firstOrNull
          ?.id,
      onCheckout: widget.onCheckout,
      onManageAddresses: _abrirDirecciones,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      HomeScreen(
        usuario: widget.usuario,
        restaurantes: widget.restaurantes,
        carrito: widget.carrito,
        cantidadCarrito: widget.cantidadCarrito,
        onOpenCart: abrirCarrito,
        onAddToCart: widget.onAddToCart,
      ),
      OrdersScreen(pedidos: widget.pedidos, onReorder: widget.onReorder),
      ProfileScreen(
        usuario: widget.usuario,
        direcciones: widget.direcciones,
        cargandoDirecciones: widget.cargandoDirecciones,
        onManageAddresses: _abrirDirecciones,
        onLogout: widget.onLogout,
      ),
    ];
    final ancho = MediaQuery.sizeOf(context).width;
    final esAmplio = ancho >= 900;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (esAmplio)
              NavigationRail(
                backgroundColor: Colors.white,
                extended: ancho >= 1150,
                selectedIndex: indice,
                onDestinationSelected: (index) {
                  setState(() => indice = index);
                },
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 22, 12, 32),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.delivery_dining,
                        color: Color(0xFFFF6B35),
                        size: 30,
                      ),
                      if (ancho >= 1150) const SizedBox(width: 10),
                      if (ancho >= 1150)
                        const Text(
                          'QueueGo',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: Text('Inicio'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.receipt_long_outlined),
                    selectedIcon: Icon(Icons.receipt_long),
                    label: Text('Pedidos'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Perfil'),
                  ),
                ],
              ),
            if (esAmplio)
              const VerticalDivider(width: 1, color: Color(0xFFEDEEF1)),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 4),
                    child: Row(
                      children: [
                        if (!esAmplio)
                          const Icon(
                            Icons.delivery_dining,
                            color: Color(0xFFFF6B35),
                            size: 28,
                          ),
                        if (!esAmplio) const SizedBox(width: 8),
                        if (!esAmplio)
                          const Text(
                            'QueueGo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          'Hola, ${widget.usuario}',
                          style: const TextStyle(
                            color: Color(0xFF777D87),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 14),
                        IconButton.filledTonal(
                          onPressed: abrirCarrito,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE9E1),
                            foregroundColor: const Color(0xFFE85C36),
                          ),
                          icon: Badge(
                            isLabelVisible: widget.cantidadCarrito > 0,
                            label: Text('${widget.cantidadCarrito}'),
                            child: const Icon(Icons.shopping_bag_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(index: indice, children: paginas),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: esAmplio
          ? null
          : NavigationBar(
              backgroundColor: Colors.white,
              selectedIndex: indice,
              onDestinationSelected: (index) {
                setState(() => indice = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Pedidos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
    );
  }
}
