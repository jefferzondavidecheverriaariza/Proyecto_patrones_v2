import '../models/direccion_entrega.dart';

abstract interface class DireccionRepository {
  Future<List<DireccionEntrega>> listar(String usuario);

  Future<void> guardar(String usuario, DireccionEntrega direccion);

  Future<void> eliminar(String usuario, String direccionId);
}
