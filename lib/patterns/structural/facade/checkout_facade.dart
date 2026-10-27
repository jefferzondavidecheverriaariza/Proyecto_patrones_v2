import '../../../models/carrito_item.dart';
import '../../../models/metodo_pago.dart';
import '../../../models/pedido.dart';
import '../../../services/pedido_service.dart';
import 'conversor_carrito.dart';
import 'generador_id_pedido.dart';
import 'resultado_checkout.dart';
import 'validador_carrito.dart';

// =====================================================
// FACADE
// =====================================================
class CheckoutFacade {
  static const String _errorSesion =
      'Debes iniciar sesión para confirmar el pedido.';
  static const String _errorCreacion = 'No fue posible confirmar el pedido.';

  final PedidoService _pedidoService;
  final ValidadorCarrito _validador;
  final ConversorCarrito _conversor;
  final GeneradorIdPedido _generadorId;

  CheckoutFacade({
    required PedidoService pedidoService,
    required ValidadorCarrito validador,
    required ConversorCarrito conversor,
    required GeneradorIdPedido generadorId,
  }) : _pedidoService = pedidoService,
       _validador = validador,
       _conversor = conversor,
       _generadorId = generadorId;

  // ---------------------------------------------------
  // Confirmar pedido
  // ---------------------------------------------------

  ResultadoCheckout confirmarPedido({
    required List<CarritoItem> carrito,
    required String? cliente,
    required String tipoEntrega,
    required MetodoPago metodoPago,
    String? direccionEntrega,
  }) {
    final errorCarrito = _validador.validar(carrito);

    if (errorCarrito != null) {
      return ResultadoCheckout.fallo(errorCarrito);
    }

    if (cliente == null) {
      return const ResultadoCheckout.fallo(_errorSesion);
    }

    if (tipoEntrega == 'Domicilio' &&
        (direccionEntrega == null || direccionEntrega.trim().isEmpty)) {
      return const ResultadoCheckout.fallo(
        'Selecciona una dirección para la entrega.',
      );
    }

    try {
      final pedido = _pedidoService.crearPedido(
        id: _generadorId.generar(),
        cliente: cliente,
        productos: _conversor.aProductos(carrito),
        tipoEntrega: tipoEntrega,
        metodoPago: metodoPago,
        direccionEntrega: direccionEntrega,
      );

      return ResultadoCheckout.exito(pedido);
    } on ArgumentError {
      // Validaciones de PedidoBuilder.build()
      return const ResultadoCheckout.fallo(_errorCreacion);
    } on StateError {
      return const ResultadoCheckout.fallo(_errorCreacion);
    }
  }

  // ---------------------------------------------------
  // Repetir pedido
  // ---------------------------------------------------

  /// Devuelve las líneas de carrito del pedido clonado,
  /// o null si no hay sesión iniciada.
  List<CarritoItem>? repetirPedido({
    required Pedido original,
    required String? cliente,
  }) {
    if (cliente == null) {
      return null;
    }

    final copia = _pedidoService.clonarPedido(
      pedidoOriginal: original,
      nuevoId: _generadorId.generar(),
      nuevoCliente: cliente,
    );

    return _conversor.desdeProductos(copia.productos);
  }
}
