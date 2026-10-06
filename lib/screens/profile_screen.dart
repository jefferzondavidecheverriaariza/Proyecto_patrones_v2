import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String usuario;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.usuario,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 15),

        Center(
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.deepOrange.shade100,
            child: const Icon(Icons.person, size: 50, color: Colors.deepOrange),
          ),
        ),

        const SizedBox(height: 15),

        Center(
          child: Text(
            usuario,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 5),

        const Center(
          child: Text('Cliente', style: TextStyle(color: Colors.grey)),
        ),

        const SizedBox(height: 30),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Dirección de entrega'),
                subtitle: const Text('Configurar ubicación'),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.payment_outlined),
                title: const Text('Métodos de pago'),
                subtitle: const Text('Administrar pagos'),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Ayuda'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ),
      ],
    );
  }
}
