import 'package:flutter/material.dart';

import '../models/direccion_entrega.dart';

class ProfileScreen extends StatelessWidget {
  final String usuario;
  final List<DireccionEntrega> direcciones;
  final bool cargandoDirecciones;
  final VoidCallback onManageAddresses;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.usuario,
    required this.direcciones,
    required this.cargandoDirecciones,
    required this.onManageAddresses,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final predeterminada = direcciones.where((item) => item.esPredeterminada);
    final direccionPrincipal = predeterminada.isEmpty
        ? null
        : predeterminada.first;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF784C), Color(0xFFE94D2D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.person_outline, size: 34),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Tu cuenta QueueGo',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_user_outlined, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Preferencias',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEEE8),
                  foregroundColor: Color(0xFFE85C36),
                  child: Icon(Icons.location_on_outlined),
                ),
                title: const Text(
                  'Direcciones de entrega',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  cargandoDirecciones
                      ? 'Cargando direcciones...'
                      : direccionPrincipal == null
                      ? 'Agrega dónde quieres recibir tus pedidos'
                      : '${direccionPrincipal.etiqueta} · ${direccionPrincipal.direccion}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: onManageAddresses,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: const ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFF1F2F5),
                  child: Icon(Icons.payment_outlined, color: Color(0xFF555B65)),
                ),
                title: Text(
                  'Métodos de pago',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Elige cómo pagar al confirmar tu pedido'),
                trailing: Icon(Icons.lock_outline, size: 19),
              ),
            ),
            const SizedBox(height: 26),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB63D31),
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
