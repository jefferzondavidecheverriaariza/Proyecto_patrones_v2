import 'bebida.dart';
import 'gaseosa.dart';
import 'hamburguesa.dart';
import 'menu_factory.dart';
import 'plato.dart';

class MenuTradicionalFactory implements MenuFactory {

  @override
  List<Plato> crearPlatos() {
    return [Hamburguesa(), HamburguesaBbq(), PapasFritas()];
  }

  @override
  Bebida crearBebida() {
    return Gaseosa();
  }
}


class HamburguesaBbq implements Plato {
  @override
  String get nombre => 'Hamburguesa BBQ';

  @override
  double get precio => 22000;
}

class PapasFritas implements Plato {
  @override
  String get nombre => 'Papas fritas';

  @override
  double get precio => 7000;
}
