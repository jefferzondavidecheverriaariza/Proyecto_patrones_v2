import 'package:flutter/material.dart';

import '../models/carrito_item.dart';
import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../patterns/singleton/app_config.dart';

class CartScreen extends StatefulWidget {
  final List<CarritoItem> carrito;

  final Pedido? Function(String tipoEntrega, MetodoPago metodoPago) onCheckout;

  const CartScreen({
    super.key,
    required this.carrito,
    required this.onCheckout,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String tipoEntrega = 'Domicilio';

  MetodoPago metodoPago = MetodoPago.efectivo;

  // =====================================================
  // TOTALES
  // =====================================================

  double get subtotal {
    return widget.carrito.fold(0, (total, item) => total + item.subtotal);
  }

  double get domicilio {
    return tipoEntrega == 'Domicilio' ? AppConfig().tarifaDomicilio : 0;
  }

  double get total {
    return subtotal + domicilio;
  }

  // =====================================================
  // FORMATO DE MONEDA
  // =====================================================

  String formatoPrecio(double valor) {
    return '\$${valor.toStringAsFixed(0)}';
  }

  // =====================================================
  // CONFIRMAR PEDIDO
  // =====================================================

  void confirmarPedido() {
    if (widget.carrito.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El carrito está vacío.')));

      return;
    }

    final pedido = widget.onCheckout(tipoEntrega, metodoPago);

    if (pedido == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No fue posible confirmar el pedido.')),
      );

      return;
    }

    Navigator.pop(context, true);
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final appConfig = AppConfig();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi carrito',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.carrito.isEmpty
          ? _buildCarritoVacio()
          : _buildCarrito(appConfig),
    );
  }

  // =====================================================
  // CARRITO VACÍO
  // =====================================================

  Widget _buildCarritoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tu carrito está vacío',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega productos de un restaurante para comenzar tu pedido.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CONTENIDO DEL CARRITO
  // =====================================================

  Widget _buildCarrito(AppConfig appConfig) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Productos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...widget.carrito.map((item) => _buildProducto(item)),

        const SizedBox(height: 24),

        _buildTipoEntrega(),

        const SizedBox(height: 24),

        _buildMetodoPago(),

        const SizedBox(height: 24),

        _buildResumen(appConfig),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: confirmarPedido,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              'Confirmar pedido · ${formatoPrecio(total)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // =====================================================
  // PRODUCTO
  // =====================================================

  Widget _buildProducto(CarritoItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.fastfood_outlined,
                color: Colors.deepOrange,
                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatoPrecio(item.producto.precio),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (item.cantidad > 1) {
                        item.disminuir();
                      } else {
                        widget.carrito.remove(item);
                      }
                    });
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),

                Text(
                  '${item.cantidad}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      item.incrementar();
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TIPO DE ENTREGA
  // =====================================================

  Widget _buildTipoEntrega() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de entrega',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Card(
          child: RadioGroup<String>(
            groupValue: tipoEntrega,
            onChanged: (valor) {
              if (valor == null) {
                return;
              }

              setState(() {
                tipoEntrega = valor;
              });
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'Domicilio',
                  title: const Text('Domicilio'),
                  subtitle: Text(
                    'Recíbelo en tu ubicación · '
                    '${formatoPrecio(AppConfig().tarifaDomicilio)}',
                  ),
                  secondary: const Icon(Icons.delivery_dining_outlined),
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'Para llevar',
                  title: const Text('Para llevar'),
                  subtitle: const Text('Recoge tu pedido en el restaurante'),
                  secondary: const Icon(Icons.storefront_outlined),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // MÉTODO DE PAGO
  // =====================================================

  Widget _buildMetodoPago() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Método de pago',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Card(
          child: RadioGroup<TipoMetodoPago>(
            groupValue: metodoPago.tipo,
            onChanged: (valor) {
              if (valor == null) {
                return;
              }

              final seleccionado = MetodoPago.disponibles.firstWhere(
                (item) => item.tipo == valor,
              );

              setState(() {
                metodoPago = seleccionado;
              });
            },
            child: Column(
              children: MetodoPago.disponibles
                  .map(
                    (metodo) => RadioListTile<TipoMetodoPago>(
                      value: metodo.tipo,
                      title: Text(metodo.nombre),
                      subtitle: Text(metodo.descripcion),
                      secondary: _iconoMetodoPago(metodo.tipo),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // ICONO MÉTODO DE PAGO
  // =====================================================

  Icon _iconoMetodoPago(TipoMetodoPago tipo) {
    switch (tipo) {
      case TipoMetodoPago.efectivo:
        return const Icon(Icons.payments_outlined);

      case TipoMetodoPago.tarjeta:
        return const Icon(Icons.credit_card_outlined);

      case TipoMetodoPago.nequi:
        return const Icon(Icons.account_balance_wallet_outlined);
    }
  }

  // =====================================================
  // RESUMEN
  // =====================================================

  Widget _buildResumen(AppConfig appConfig) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _filaResumen('Subtotal', subtotal),

            const SizedBox(height: 10),

            _filaResumen('Domicilio', domicilio),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatoPrecio(total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Moneda: ${appConfig.moneda}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // FILA DEL RESUMEN
  // =====================================================

  Widget _filaResumen(String titulo, double valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: TextStyle(color: Colors.grey.shade700)),
        Text(
          formatoPrecio(valor),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
