import 'package:flutter/material.dart';

import '../models/pedido.dart';

class OrdersScreen extends StatelessWidget {
  final List<Pedido> pedidos;

  final void Function(Pedido pedido) onReorder;

  const OrdersScreen({
    super.key,
    required this.pedidos,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 15),
            Text(
              'Todavía no tienes pedidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Tus pedidos aparecerán aquí.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        const Text(
          'Mis pedidos',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        const Text(
          'Consulta y repite tus pedidos anteriores.',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 20),

        ...pedidos.map((pedido) {
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedido #${pedido.id.substring(pedido.id.length > 4 ? pedido.id.length - 4 : 0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Completado',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(pedido.tipo, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.payment_outlined, size: 17),
                      const SizedBox(width: 6),
                      Text(pedido.metodoPago.nombre),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text('${pedido.productos.length} productos'),

                  const SizedBox(height: 10),

                  Text(
                    '\$${pedido.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        onReorder(pedido);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pedido agregado nuevamente al carrito.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Repetir pedido'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
