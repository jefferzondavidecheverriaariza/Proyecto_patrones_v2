class DireccionEntrega {
  final String id;
  final String etiqueta;
  final String direccion;
  final String ciudad;
  final String referencia;
  final bool esPredeterminada;

  const DireccionEntrega({
    required this.id,
    required this.etiqueta,
    required this.direccion,
    required this.ciudad,
    this.referencia = '',
    this.esPredeterminada = false,
  });

  String get resumen =>
      [direccion, ciudad, if (referencia.isNotEmpty) referencia].join(' · ');

  DireccionEntrega copyWith({bool? esPredeterminada}) {
    return DireccionEntrega(
      id: id,
      etiqueta: etiqueta,
      direccion: direccion,
      ciudad: ciudad,
      referencia: referencia,
      esPredeterminada: esPredeterminada ?? this.esPredeterminada,
    );
  }

  factory DireccionEntrega.fromJson(Map<String, dynamic> json) {
    return DireccionEntrega(
      id: json['id'] as String,
      etiqueta: json['etiqueta'] as String,
      direccion: json['direccion'] as String,
      ciudad: json['ciudad'] as String,
      referencia: json['referencia'] as String? ?? '',
      esPredeterminada: json['esPredeterminada'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'etiqueta': etiqueta,
    'direccion': direccion,
    'ciudad': ciudad,
    'referencia': referencia,
    'esPredeterminada': esPredeterminada,
  };
}
