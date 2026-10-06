import 'package:flutter/material.dart';

import '../models/carrito_item.dart';
import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';

import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  final String usuario;
  final List<Restaurante> restaurantes;
  final List<CarritoItem> carrito;
  final List<Pedido> pedidos;
  final int cantidadCarrito;

  final void Function(Producto producto) onAddToCart;

  final Pedido? Function(
    String tipoEntrega,
    MetodoPago metodoPago,
  ) onCheckout;

  final void Function(Pedido pedido) onReorder;

  final VoidCallback onLogout;

  const MainShell({
    super.key,
    required this.usuario,
    required this.restaurantes,
    required this.carrito,
    required this.pedidos,
    required this.cantidadCarrito,
    required this.onAddToCart,
    required this.onCheckout,
    required this.onReorder,
    required this.onLogout,
  });

  @override
  State<MainShell> createState() =>
      _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int indice = 0;

  Future<void> abrirCarrito() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(
          carrito: widget.carrito,
          onCheckout: widget.onCheckout,
        ),
      ),
    );

    if (resultado == true && mounted) {
      setState(() {});

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Pedido confirmado correctamente.',
          ),
        ),
      );
    }
  }

  String get titulo {
    switch (indice) {
      case 1:
        return 'Mis pedidos';

      case 2:
        return 'Mi perfil';

      default:
        return 'QueueGo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      HomeScreen(
        usuario: widget.usuario,
        restaurantes: widget.restaurantes,
        carrito: widget.carrito,
        cantidadCarrito:
            widget.cantidadCarrito,
        onOpenCart: abrirCarrito,
        onAddToCart:
            widget.onAddToCart,
      ),
      OrdersScreen(
        pedidos: widget.pedidos,
        onReorder: widget.onReorder,
      ),
      ProfileScreen(
        usuario: widget.usuario,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: abrirCarrito,
            icon: Badge(
              isLabelVisible:
                  widget.cantidadCarrito > 0,
              label: Text(
                '${widget.cantidadCarrito}',
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: IndexedStack(
        index: indice,
        children: pantallas,
      ),

      bottomNavigationBar:
          NavigationBar(
        selectedIndex: indice,
        onDestinationSelected:
            (nuevoIndice) {
          setState(() {
            indice = nuevoIndice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            selectedIcon: Icon(
              Icons.receipt_long,
            ),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}