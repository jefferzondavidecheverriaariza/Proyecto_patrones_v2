import 'bebida.dart';
import 'plato.dart';

abstract class MenuFactory {

  List<Plato> crearPlatos();

  Bebida crearBebida();
}