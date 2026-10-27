import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:queuego/models/direccion_entrega.dart';
import 'package:queuego/services/local_direccion_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalDireccionRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalDireccionRepository();
  });

  test(
    'guarda direcciones por usuario y mantiene una predeterminada',
    () async {
      const casa = DireccionEntrega(
        id: 'home',
        etiqueta: 'Casa',
        direccion: 'Calle 10 # 20-30',
        ciudad: 'Bogotá',
      );
      const trabajo = DireccionEntrega(
        id: 'work',
        etiqueta: 'Trabajo',
        direccion: 'Carrera 7 # 12-34',
        ciudad: 'Bogotá',
        esPredeterminada: true,
      );

      await repository.guardar('Cliente', casa);
      await repository.guardar('Cliente', trabajo);

      final direcciones = await repository.listar('Cliente');
      expect(direcciones, hasLength(2));
      expect(
        direcciones.where((direccion) => direccion.esPredeterminada).single.id,
        'work',
      );
      expect(await repository.listar('Otra persona'), isEmpty);
    },
  );

  test(
    'al eliminar la dirección principal elige otra como principal',
    () async {
      await repository.guardar(
        'Cliente',
        const DireccionEntrega(
          id: 'home',
          etiqueta: 'Casa',
          direccion: 'Calle 10',
          ciudad: 'Bogotá',
        ),
      );
      await repository.guardar(
        'Cliente',
        const DireccionEntrega(
          id: 'work',
          etiqueta: 'Trabajo',
          direccion: 'Carrera 7',
          ciudad: 'Bogotá',
        ),
      );

      await repository.eliminar('Cliente', 'home');

      final restante = (await repository.listar('Cliente')).single;
      expect(restante.id, 'work');
      expect(restante.esPredeterminada, isTrue);
    },
  );
}
