import 'package:flutter/material.dart';

import 'controllers/queuego_controller.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const QueueGoApp());
}

class QueueGoApp extends StatefulWidget {
  const QueueGoApp({super.key});

  @override
  State<QueueGoApp> createState() => _QueueGoAppState();
}

class _QueueGoAppState extends State<QueueGoApp> {
  final QueueGoController controller = QueueGoController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: controller.config.nombreAplicacion,

          theme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange,
              brightness: Brightness.light,
            ),

            scaffoldBackgroundColor: const Color(0xFFF8F8F8),

            appBarTheme: const AppBarTheme(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),

            cardTheme: CardThemeData(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),

          home: controller.sesionIniciada
              ? MainShell(
                  usuario: controller.usuarioActual!,
                  restaurantes: controller.restaurantes,
                  carrito: controller.carrito,
                  pedidos: controller.pedidos,
                  cantidadCarrito: controller.cantidadCarrito,
                  onAddToCart: controller.agregarAlCarrito,
                  onCheckout: controller.finalizarPedido,
                  onReorder: controller.repetirPedido,
                  onLogout: controller.cerrarSesion,
                )
              : LoginScreen(onLogin: controller.iniciarSesion),
        );
      },
    );
  }
}
