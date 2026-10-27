import 'package:flutter/foundation.dart';

import '../models/carrito_item.dart';
import '../models/direccion_entrega.dart';
import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../models/restaurante.dart';

import '../patterns/creational/singleton/app_config.dart';

import '../services/pedido_service.dart';
import '../services/pedido_service_impl.dart';
import '../services/direccion_repository.dart';
import '../services/local_direccion_repository.dart';
import '../patterns/structural/facade/checkout_facade.dart';
import '../patterns/structural/facade/conversor_carrito.dart';
import '../patterns/structural/facade/generador_id_pedido.dart';
import '../patterns/structural/facade/validador_carrito.dart';

class QueueGoController extends ChangeNotifier {
  QueueGoController({DireccionRepository? direccionRepository})
    : _direccionRepository = direccionRepository ?? LocalDireccionRepository();

  final DireccionRepository _direccionRepository;

  // =====================================================
  // CONFIGURACIÓN
  // =====================================================

  final AppConfig config = AppConfig();

  // =====================================================
  // SERVICIO DE PEDIDOS
  // =====================================================

  final PedidoService pedidoService = PedidoServiceImpl();

  late final CheckoutFacade checkoutFacade = CheckoutFacade(
    pedidoService: pedidoService,
    validador: const ValidadorCarrito(),
    conversor: const ConversorCarrito(),
    generadorId: const GeneradorIdPedido(),
  );

  // =====================================================
  // SESIÓN
  // =====================================================

  String? usuarioActual;

  bool get sesionIniciada => usuarioActual != null;

  final List<DireccionEntrega> direcciones = [];
  bool cargandoDirecciones = false;
  String? errorDirecciones;
  int _versionCargaDirecciones = 0;

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

  Future<void> cargarDirecciones() async {
    final usuario = usuarioActual;
    if (usuario == null) return;

    final versionSolicitud = ++_versionCargaDirecciones;
    cargandoDirecciones = true;
    errorDirecciones = null;
    notifyListeners();
    try {
      final cargadas = await _direccionRepository.listar(usuario);
      if (usuarioActual != usuario ||
          versionSolicitud != _versionCargaDirecciones) {
        return;
      }
      direcciones
        ..clear()
        ..addAll(cargadas);
    } on Exception catch (error, stackTrace) {
      if (usuarioActual != usuario ||
          versionSolicitud != _versionCargaDirecciones) {
        return;
      }
      errorDirecciones = 'No se pudieron cargar las direcciones guardadas.';
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'QueueGo',
          context: ErrorDescription('al cargar las direcciones guardadas'),
        ),
      );
    } finally {
      if (versionSolicitud == _versionCargaDirecciones) {
        cargandoDirecciones = false;
        notifyListeners();
      }
    }
  }

  Future<List<DireccionEntrega>> recargarDirecciones() async {
    await cargarDirecciones();
    if (errorDirecciones != null) {
      throw StateError(errorDirecciones!);
    }
    return List.unmodifiable(direcciones);
  }

  Future<List<DireccionEntrega>> guardarDireccion(
    DireccionEntrega direccion,
  ) async {
    final usuario = usuarioActual;
    if (usuario == null) {
      throw StateError('Inicia sesión para guardar una dirección.');
    }

    await _direccionRepository.guardar(usuario, direccion);
    await _actualizarDirecciones(usuario);
    return List.unmodifiable(direcciones);
  }

  Future<List<DireccionEntrega>> eliminarDireccion(String direccionId) async {
    final usuario = usuarioActual;
    if (usuario == null) {
      throw StateError('Inicia sesión para eliminar una dirección.');
    }

    await _direccionRepository.eliminar(usuario, direccionId);
    await _actualizarDirecciones(usuario);
    return List.unmodifiable(direcciones);
  }

  Future<void> _actualizarDirecciones(String usuario) async {
    final actualizadas = await _direccionRepository.listar(usuario);
    if (usuarioActual != usuario) return;
    direcciones
      ..clear()
      ..addAll(actualizadas);
    notifyListeners();
  }

  void cerrarSesion() {
    usuarioActual = null;
    carrito.clear();
    direcciones.clear();
    errorDirecciones = null;
    cargandoDirecciones = false;
    _versionCargaDirecciones++;

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

  Pedido? finalizarPedido(
    String tipoEntrega,
    MetodoPago metodoPago,
    String? direccionEntrega,
  ) {
    final resultado = checkoutFacade.confirmarPedido(
      carrito: carrito,
      cliente: usuarioActual,
      tipoEntrega: tipoEntrega,
      metodoPago: metodoPago,
      direccionEntrega: direccionEntrega,
    );
    final pedidoFinal = resultado.pedido;
    if (pedidoFinal == null) return null;
    pedidos.insert(0, pedidoFinal);
    carrito.clear();
    notifyListeners();
    return pedidoFinal;
  }

  // =====================================================
  // REPETIR PEDIDO
  // =====================================================

  void repetirPedido(Pedido pedidoOriginal) {
    final copia = checkoutFacade.repetirPedido(
      original: pedidoOriginal,
      cliente: usuarioActual,
    );
    if (copia == null) return;
    carrito
      ..clear()
      ..addAll(copia);
    notifyListeners();
  }
}
