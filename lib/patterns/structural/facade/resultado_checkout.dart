import '../../../models/pedido.dart';

// =====================================================
// FACADE - OBJETO DE APOYO
// Resultado del proceso de confirmación: éxito con
// pedido, o fallo con mensaje para el usuario.
// =====================================================
class ResultadoCheckout {
  final Pedido? pedido;
  final String? error;

  const ResultadoCheckout.exito(Pedido this.pedido) : error = null;

  const ResultadoCheckout.fallo(String this.error) : pedido = null;

  bool get exitoso => pedido != null;
}
