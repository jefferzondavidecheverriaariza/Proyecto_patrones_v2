import 'package:flutter_test/flutter_test.dart';
import 'package:queuego/models/carrito_item.dart';
import 'package:queuego/models/metodo_pago.dart';
import 'package:queuego/models/pedido_domicilio.dart';
import 'package:queuego/models/producto.dart';
import 'package:queuego/patterns/structural/facade/checkout_facade.dart';
import 'package:queuego/patterns/structural/facade/conversor_carrito.dart';
import 'package:queuego/patterns/structural/facade/generador_id_pedido.dart';
import 'package:queuego/patterns/structural/facade/validador_carrito.dart';
import 'package:queuego/services/pedido_service_impl.dart';

void main() {
  late CheckoutFacade checkout;

  setUp(() {
    checkout = CheckoutFacade(
      pedidoService: PedidoServiceImpl(),
      validador: const ValidadorCarrito(),
      conversor: const ConversorCarrito(),
      generadorId: const GeneradorIdPedido(),
    );
  });

  test('requiere una dirección para confirmar un pedido a domicilio', () {
    final resultado = checkout.confirmarPedido(
      carrito: [
        CarritoItem(
          producto: Producto(
            id: 'producto-1',
            nombre: 'Hamburguesa',
            precio: 12000,
          ),
        ),
      ],
      cliente: 'Cliente',
      tipoEntrega: 'Domicilio',
      metodoPago: MetodoPago.efectivo,
    );

    expect(resultado.exitoso, isFalse);
    expect(resultado.error, 'Selecciona una dirección para la entrega.');
  });

  test('mantiene la dirección seleccionada en el pedido de domicilio', () {
    const direccion = 'Casa: Calle 10 # 20-30 · Bogotá';
    final resultado = checkout.confirmarPedido(
      carrito: [
        CarritoItem(
          producto: Producto(
            id: 'producto-1',
            nombre: 'Hamburguesa',
            precio: 12000,
          ),
        ),
      ],
      cliente: 'Cliente',
      tipoEntrega: 'Domicilio',
      metodoPago: MetodoPago.efectivo,
      direccionEntrega: direccion,
    );

    expect(resultado.pedido, isA<PedidoDomicilio>());
    expect(resultado.pedido?.direccionEntrega, direccion);
  });
}
