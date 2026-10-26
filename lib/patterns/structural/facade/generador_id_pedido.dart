// =====================================================
// FACADE - SUBSISTEMA
// Generación de identificadores de pedido.
// =====================================================
class GeneradorIdPedido {
  const GeneradorIdPedido();

  String generar() => DateTime.now().millisecondsSinceEpoch.toString();
}
