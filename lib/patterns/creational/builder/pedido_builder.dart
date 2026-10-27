import '../../../models/metodo_pago.dart';
import '../../../models/pedido.dart';
import '../../../models/producto.dart';
import '../../creational/singleton/app_config.dart';

/// Interfaz o clase constructora siguiendo el Patrón Builder (GoF)
class PedidoBuilder {
  String _id = '';
  String _cliente = '';
  String _tipo = 'Para llevar';
  String? _direccionEntrega;
  double _costoDomicilio = 0.0;
  MetodoPago _metodoPago = MetodoPago.efectivo;
  final List<Producto> _productos = [];

  /// Establece el identificador único del pedido
  PedidoBuilder conId(String id) {
    _id = id.trim();
    return this;
  }

  /// Establece el nombre del cliente que realiza el pedido
  PedidoBuilder conCliente(String cliente) {
    _cliente = cliente.trim();
    return this;
  }

  /// Define el tipo de pedido y calcula automáticamente el costo de envío usando AppConfig (Singleton)
  PedidoBuilder conTipo(String tipo) {
    _tipo = tipo;
    _costoDomicilio = (tipo.toLowerCase() == 'domicilio')
        ? AppConfig().tarifaDomicilio
        : 0.0;
    return this;
  }

  PedidoBuilder conDireccionEntrega(String? direccion) {
    _direccionEntrega = direccion?.trim();
    return this;
  }

  /// Asigna el método de pago seleccionado
  PedidoBuilder conMetodoPago(MetodoPago metodoPago) {
    _metodoPago = metodoPago;
    return this;
  }

  /// Añade un producto individual al listado del pedido
  PedidoBuilder agregarProducto(Producto producto) {
    _productos.add(producto);
    return this;
  }

  /// Permite agregar una lista completa de productos de una vez (ej: desde el carrito)
  PedidoBuilder agregarProductos(List<Producto> productos) {
    _productos.addAll(productos);
    return this;
  }

  /// Valida las reglas de negocio y construye la instancia final de [Pedido]
  Pedido build() {
    if (_id.isEmpty) {
      throw ArgumentError('El campo ID del pedido no puede estar vacío.');
    }
    if (_cliente.isEmpty) {
      throw ArgumentError('El campo Cliente no puede estar vacío.');
    }
    if (_productos.isEmpty) {
      throw StateError(
        'El pedido debe contener al menos un producto registrado.',
      );
    }

    return Pedido(
      id: _id,
      cliente: _cliente,
      productos: List.unmodifiable(_productos),
      tipo: _tipo,
      direccionEntrega: _direccionEntrega,
      metodoPago: _metodoPago,
      costoDomicilio: _costoDomicilio,
    );
  }
}

/// Director opcional del Patrón Builder para encapsular recetas o combos predefinidos
class PedidoDirector {
  final PedidoBuilder _builder;

  PedidoDirector(this._builder);

  /// Construye un pedido rápido preconfigurado para mesa local
  Pedido construirPedidoLocalRapido({
    required String id,
    required String cliente,
    required List<Producto> productosDefault,
  }) {
    return _builder
        .conId(id)
        .conCliente(cliente)
        .conTipo('Local')
        .conMetodoPago(MetodoPago.efectivo)
        .agregarProductos(productosDefault)
        .build();
  }
}
