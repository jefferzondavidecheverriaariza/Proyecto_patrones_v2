class AppConfig {
  // =====================================================
  // SINGLETON
  //
  // Solo existe una instancia de esta configuración.
  // =====================================================

  static final AppConfig _instance = AppConfig._internal();

  AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  // =====================================================
  // CONFIGURACIÓN GLOBAL
  // =====================================================

  String nombreAplicacion = 'QueueGo';

  String moneda = 'COP';

  bool modoPrueba = true;

  double tarifaDomicilio = 5000;

  String get descripcion {
    return '$nombreAplicacion - Moneda: $moneda';
  }
}

