import 'package:flutter/material.dart';
import 'controllers/queuego_controller.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() => runApp(const QueueGoApp());

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
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: controller.config.nombreAplicacion,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7F9),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF20232A),
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFEDEEF1)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE7E8EC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE7E8EC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              direcciones: controller.direcciones,
              cargandoDirecciones: controller.cargandoDirecciones,
              errorDirecciones: controller.errorDirecciones,
              onLoadAddresses: controller.cargarDirecciones,
              onReloadAddresses: controller.recargarDirecciones,
              onSaveAddress: controller.guardarDireccion,
              onDeleteAddress: controller.eliminarDireccion,
              onAddToCart: controller.agregarAlCarrito,
              onCheckout: controller.finalizarPedido,
              onReorder: controller.repetirPedido,
              onLogout: controller.cerrarSesion,
            )
          : LoginScreen(onLogin: controller.iniciarSesion),
    ),
  );
}
