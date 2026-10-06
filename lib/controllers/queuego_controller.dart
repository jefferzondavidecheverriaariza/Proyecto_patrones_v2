import 'package:flutter/foundation.dart';

import '../models/carrito_item.dart';
import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';

import '../patterns/singleton/app_config.dart';

import '../services/pedido_service.dart';
import '../services/pedido_service_impl.dart';

class QueueGoController extends ChangeNotifier {
  // =====================================================
  // CONFIGURACIÓN
  // =====================================================

  final AppConfig config = AppConfig();

  // =====================================================
  // SERVICIO DE PEDIDOS
  // =====================================================

  final PedidoService pedidoService = PedidoServiceImpl();

  // =====================================================
  // SESIÓN
  // =====================================================

  String? usuarioActual;

  bool get sesionIniciada => usuarioActual != null;

  // =====================================================
  // CARRITO
  // =====================================================

  final List<CarritoItem> carrito = [];

  int get cantidadCarrito {
    return carrito.fold(0, (total, item) => total + item.cantidad);
  }

  double get totalCarrito {
    return carrito.fold(0, (total, item) => total + item.subtotal);
  }

  // =====================================================
  // PEDIDOS
  // =====================================================

  final List<Pedido> pedidos = [];

  // =====================================================
  // RESTAURANTES
  // =====================================================

  final List<Restaurante> restaurantes = [
    Restaurante(
      id: '1',
      nombre: 'Burger House',
      categoria: 'Hamburguesas',
      descripcion: 'Hamburguesas, combos y acompañamientos.',
      tiempoEntrega: '25-35 min',
      tipoMenu: 'tradicional',
    ),
    Restaurante(
      id: '2',
      nombre: 'Sabor Caribe',
      categoria: 'Comida rápida',
      descripcion: 'Sabores del Caribe colombiano.',
      tiempoEntrega: '30-40 min',
      tipoMenu: 'caribe',
    ),
    Restaurante(
      id: '3',
      nombre: 'Verde Natural',
      categoria: 'Saludable',
      descripcion: 'Opciones frescas y saludables.',
      tiempoEntrega: '20-30 min',
      tipoMenu: 'saludable',
    ),
  ];

  // =====================================================
  // SESIÓN
  // =====================================================

  void iniciarSesion(String nombre) {
    usuarioActual = nombre.trim().isEmpty ? 'Cliente' : nombre.trim();

    notifyListeners();
  }

  void cerrarSesion() {
    usuarioActual = null;
    carrito.clear();

    notifyListeners();
  }

  // =====================================================
  // CARRITO
  // =====================================================

  void agregarAlCarrito(Producto producto) {
    final indice = carrito.indexWhere(
      (item) => item.producto.id == producto.id,
    );

    if (indice >= 0) {
      carrito[indice].incrementar();
    } else {
      carrito.add(CarritoItem(producto: producto));
    }

    notifyListeners();
  }

  void aumentarCantidad(int indice) {
    if (indice < 0 || indice >= carrito.length) {
      return;
    }

    carrito[indice].incrementar();

    notifyListeners();
  }

  void disminuirCantidad(int indice) {
    if (indice < 0 || indice >= carrito.length) {
      return;
    }

    if (carrito[indice].cantidad > 1) {
      carrito[indice].disminuir();
    } else {
      carrito.removeAt(indice);
    }

    notifyListeners();
  }

  void eliminarDelCarrito(int indice) {
    if (indice < 0 || indice >= carrito.length) {
      return;
    }

    carrito.removeAt(indice);

    notifyListeners();
  }

  void vaciarCarrito() {
    carrito.clear();

    notifyListeners();
  }

  // =====================================================
  // FINALIZAR PEDIDO
  // =====================================================

  Pedido? finalizarPedido(String tipoEntrega, MetodoPago metodoPago) {
    if (carrito.isEmpty || usuarioActual == null) {
      return null;
    }

    final productos = <Producto>[];

    for (final item in carrito) {
      for (int i = 0; i < item.cantidad; i++) {
        productos.add(item.producto);
      }
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final pedidoFinal = pedidoService.crearPedido(
      id: id,
      cliente: usuarioActual!,
      productos: productos,
      tipoEntrega: tipoEntrega,
      metodoPago: metodoPago,
    );

    pedidos.insert(0, pedidoFinal);

    carrito.clear();

    notifyListeners();

    return pedidoFinal;
  }

  // =====================================================
  // REPETIR PEDIDO
  // =====================================================

  void repetirPedido(Pedido pedidoOriginal) {
    if (usuarioActual == null) {
      return;
    }

    final copia = pedidoService.clonarPedido(
      pedidoOriginal: pedidoOriginal,
      nuevoId: DateTime.now().millisecondsSinceEpoch.toString(),
      nuevoCliente: usuarioActual!,
    );

    carrito.clear();

    for (final producto in copia.productos) {
      final indice = carrito.indexWhere(
        (item) => item.producto.id == producto.id,
      );

      if (indice >= 0) {
        carrito[indice].incrementar();
      } else {
        carrito.add(CarritoItem(producto: producto));
      }
    }

    notifyListeners();
  }
}
