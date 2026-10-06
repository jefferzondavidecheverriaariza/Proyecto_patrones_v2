import '../../models/metodo_pago.dart';
import '../../models/pedido.dart';
import '../../models/producto.dart';
import '../singleton/app_config.dart';

class PedidoBuilder {
  String _id = '';
  String _cliente = '';
  String _tipo = 'Para llevar';
  double _costoDomicilio = 0;

  MetodoPago _metodoPago = MetodoPago.efectivo;

  final List<Producto> _productos = [];

  // =====================================================
  // BUILDER
  // =====================================================

  PedidoBuilder conId(String id) {
    _id = id;
    return this;
  }

  PedidoBuilder conCliente(String cliente) {
    _cliente = cliente;
    return this;
  }

  PedidoBuilder conTipo(String tipo) {
    _tipo = tipo;

    _costoDomicilio = tipo == 'Domicilio' ? AppConfig().tarifaDomicilio : 0;

    return this;
  }

  PedidoBuilder conMetodoPago(MetodoPago metodoPago) {
    _metodoPago = metodoPago;
    return this;
  }

  PedidoBuilder agregarProducto(Producto producto) {
    _productos.add(producto);
    return this;
  }

  Pedido build() {
    if (_id.isEmpty) {
      throw Exception('El pedido necesita un ID');
    }

    if (_cliente.isEmpty) {
      throw Exception('El pedido necesita un cliente');
    }

    if (_productos.isEmpty) {
      throw Exception('El pedido debe tener al menos un producto');
    }

    return Pedido(
      id: _id,
      cliente: _cliente,
      productos: List.unmodifiable(_productos),
      tipo: _tipo,
      metodoPago: _metodoPago,
      costoDomicilio: _costoDomicilio,
    );
  }
}
