import 'menu_caribe_factory.dart';
import 'menu_factory.dart';
import 'menu_saludable_factory.dart';
import 'menu_tradicional_factory.dart';

class MenuFactoryResolver {
  const MenuFactoryResolver._();

  static MenuFactory para(String tipoMenu) {
    switch (tipoMenu.toLowerCase()) {
      case 'caribe':
        return MenuCaribeFactory();
      case 'saludable':
        return MenuSaludableFactory();
      default:
        return MenuTradicionalFactory();
    }
  }
}
