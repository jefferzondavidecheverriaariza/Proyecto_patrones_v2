# QueueGo

**Aplicación de domicilios para demostración de patrones de diseño**

## 1. Descripción del proyecto

QueueGo es una aplicación de domicilios desarrollada en Flutter y Dart, creada como proyecto académico para demostrar la aplicación práctica de patrones de diseño creacionales y estructurales, principios SOLID y buenas prácticas de desarrollo de software.

La aplicación representa el funcionamiento de una plataforma de domicilios en la que los usuarios pueden consultar restaurantes, seleccionar productos, agregarlos al carrito, configurar el tipo de entrega y método de pago, confirmar pedidos y consultar o repetir pedidos anteriores.

QueueGo busca digitalizar la coordinación de restaurantes, clientes, repartidores y central de operaciones, reduciendo la dependencia de la comunicación manual y proporcionando trazabilidad sobre pedidos y entregas.

## 2. Tecnologías utilizadas

- Flutter.
- Dart.
- SharedPreferences (persistencia local de direcciones).
- Flutter Web.

> **Estado de integración:** esta versión usa inicio de sesión de demostración y
> guarda las direcciones en el dispositivo. Supabase todavía no está conectado
> al código ni configurado en las dependencias; por eso los datos locales no se
> sincronizan entre dispositivos.

## 3. Roles del sistema

- **Cliente:** consulta restaurantes y realiza pedidos.
- **Restaurante:** administra su operación y gestiona pedidos.
- **Repartidor:** gestiona las entregas asignadas.
- **Central:** coordina y supervisa las operaciones del sistema.

## 4. Funcionalidades

### Funcionalidades actuales

- Inicio de sesión de demostración.
- Catálogo local de restaurantes, menús y combos.
- Carrito con personalización de productos, extras y bebidas.
- Confirmación de pedidos con modalidad de entrega y método de pago.
- Consulta y repetición de pedidos durante la sesión.
- Gestión de varias direcciones de entrega, guardadas localmente por usuario
  introducido en la sesión.
- Diseño adaptable a móvil y escritorio.

### Funcionalidades en desarrollo

- Autenticación real y sincronización de datos con Supabase.
- Persistencia remota de restaurantes, productos y pedidos.
- Gestión de pedidos del restaurante.
- Asignación de entregas.
- GPS del repartidor.
- Seguimiento en tiempo real.
- Visualización de mapas.
- Reportes e indicadores.
- Tema visual definitivo.

## 5. Patrones de diseño implementados

QueueGo incorpora ocho patrones de diseño, organizados en dos categorías: creacionales y estructurales.

### 5.1. Patrones creacionales

Se utilizan para organizar y controlar la creación de objetos dentro de la aplicación.

| Patrón | Aplicación en QueueGo |
|---|---|
| Singleton | AppConfig mantiene una instancia compartida de la configuración de la aplicación. |
| Builder | PedidoBuilder permite construir pedidos progresivamente mediante diferentes atributos. |
| Factory Method | PedidoFactory y sus implementaciones crean pedidos según el tipo de entrega, como domicilio o pedido local. |
| Abstract Factory | MenuFactory y sus fábricas concretas generan familias de platos, bebidas, opciones de bebida y combos según el tipo de menú. |
| Prototype | PedidoPrototype permite clonar pedidos anteriores para facilitar la repetición de pedidos. |

### 5.2. Patrones estructurales

Se utilizan para organizar las relaciones entre objetos y facilitar la comunicación entre diferentes componentes del sistema.

| Patrón | Aplicación en QueueGo |
|---|---|
| Adapter | PlatoProductoAdapter y BebidaProductoAdapter adaptan los objetos Plato y Bebida al modelo Producto utilizado por el carrito. |
| Decorator | PlatoDecorator permite agregar dinámicamente los extras de cada menú —incluidos queso, carnes, aguacate y aderezos— al nombre y precio del plato. TipoExtra centraliza su catálogo y aplicación. |
| Facade | CheckoutFacade proporciona una interfaz unificada para coordinar la validación del carrito, conversión de productos, generación del identificador y creación del pedido. |

Los combos y variantes de bebidas se definen en las fábricas concretas de
Abstract Factory; las reglas de extras pertenecen al catálogo del patrón
Decorator. La pantalla del restaurante se limita a presentar estos datos y a
recoger la selección del cliente.

Las direcciones se gestionan mediante `DireccionRepository`, con una
implementación local basada en SharedPreferences. Esta abstracción permite
incorporar una implementación remota más adelante sin acoplar la interfaz a
Supabase.

### 5.3. Organización de los patrones

Los patrones se encuentran organizados de la siguiente manera:

```text
lib/
└── patterns/
    ├── creational/
    │   ├── abstract_factory/
    │   ├── builder/
    │   ├── factory_method/
    │   ├── prototype/
    │   └── singleton/
    │
    └── structural/
        ├── adapter/
        ├── decorator/
        └── facade/
```

## 6. Arquitectura del proyecto

La aplicación separa la interfaz, el controlador de estado, los servicios y los
modelos. Para las direcciones, la interfaz depende de `DireccionRepository` y
su implementación local guarda los datos en SharedPreferences.

```text
screens -> QueueGoController -> DireccionRepository -> LocalDireccionRepository
                                                   -> SharedPreferences
```

Los patrones de diseño organizan la creación de menús y pedidos, la adaptación
de platos al carrito, la personalización con extras y la coordinación del
checkout. La implementación remota puede añadirse detrás de la abstracción del
repositorio cuando se configure Supabase.

## 7. Base de datos

La aplicación actual no usa una base de datos remota. Para una futura integración
con Supabase se deberán definir y proteger las tablas de perfiles, restaurantes,
productos y pedidos. Las direcciones deberán asociarse al identificador
autenticado del cliente y protegerse con políticas RLS; no basta con crear una
tabla si todavía no existe autenticación real en la aplicación.

## 8. Principios SOLID aplicados

- **SRP (Single Responsibility Principle):** pantallas, controlador, repositorios,
  modelos y patrones tienen responsabilidades diferenciadas.
- **OCP (Open/Closed Principle):** `DireccionRepository` permite incorporar otra
  persistencia sin que las pantallas conozcan SharedPreferences o Supabase.
- **DIP (Dependency Inversion Principle):** el controlador depende de la
  abstracción `DireccionRepository`, no de su implementación local.
- **ISP (Interface Segregation Principle):** el contrato del repositorio expone
  únicamente las operaciones requeridas para administrar direcciones.
- **LSP (Liskov Substitution Principle):** cualquier implementación del contrato
  de direcciones debe respetar las operaciones y sus resultados.

## 9. Refactorización y control de cambios

Los principales cambios realizados durante el desarrollo incluyen:

1. Separación de responsabilidades entre interfaz, controlador, servicios y
   modelos.
2. Incorporación de patrones creacionales y estructurales para menús, pedidos,
   extras y checkout.
3. Gestión local de direcciones mediante un repositorio sustituible.
4. Adaptación de las pantallas principales a tamaños móviles y de escritorio.

## 10. Documentación

La documentación del proyecto se organiza en la carpeta `docs/`:

```text
docs/
├── informe_solid_antipatrones.md
├── control_cambios.md
├── arquitectura.md
├── uml_clases_actualizado.puml
├── uml_clases_actualizado.png
├── uml_casos_uso.puml
└── uml/
    └── estructurales/
        ├── 08_adapter_ANTES.puml
        ├── 08_adapter_DESPUES.puml
        ├── 09_decorator_ANTES.puml
        ├── 09_decorator_DESPUES.puml
        ├── 10_facade_ANTES.puml
        └── 10_facade_DESPUES.puml
```

Los diagramas UML representan la estructura y las relaciones entre las clases. Los diagramas ANTES muestran una representación conceptual de la solución sin aplicar el patrón, mientras que los diagramas DESPUÉS muestran la organización propuesta mediante el patrón correspondiente.

## 11. Ejecución del proyecto

Para ejecutar el proyecto localmente se requiere tener Flutter instalado y configurar las dependencias.

Clonar el repositorio:

```bash
git clone https://github.com/jefferzondavidecheverriaariza/Proyecto_patrones_v2.git
```

Ingresar a la carpeta:

```bash
cd Proyecto_Patrones
```

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar la aplicación:

```bash
flutter run
```

Analizar el código:

```bash
flutter analyze
```

Ejecutar las pruebas:

```bash
flutter test
```

## 12. Declaración de uso de inteligencia artificial

Durante el desarrollo de QueueGo se utilizó inteligencia artificial como herramienta de apoyo técnico para analizar código, identificar oportunidades de refactorización, proponer estructuras, resolver errores, comprender patrones de diseño y apoyar la elaboración de la documentación y los diagramas UML.
