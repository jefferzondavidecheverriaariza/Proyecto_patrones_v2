# QueueGo

**Aplicación de domicilios para demostración de patrones de diseño**

## 1. Descripción del proyecto

QueueGo es una aplicación de domicilios desarrollada en Flutter y Dart, creada como proyecto académico para demostrar la aplicación práctica de patrones de diseño creacionales y estructurales, principios SOLID y buenas prácticas de desarrollo de software.

La aplicación representa el funcionamiento de una plataforma de domicilios en la que los usuarios pueden consultar restaurantes, seleccionar productos, agregarlos al carrito, configurar el tipo de entrega y método de pago, confirmar pedidos y consultar o repetir pedidos anteriores.

QueueGo busca digitalizar la coordinación de restaurantes, clientes, repartidores y central de operaciones, reduciendo la dependencia de la comunicación manual y proporcionando trazabilidad sobre pedidos y entregas.

## 2. Tecnologías utilizadas

- Flutter.
- Dart.
- Supabase Auth.
- Supabase PostgreSQL.
- Supabase RLS (Row Level Security).
- Supabase Realtime.
- Riverpod.
- Geolocator.
- Flutter Web.

## 3. Roles del sistema

- **Cliente:** consulta restaurantes y realiza pedidos.
- **Restaurante:** administra su operación y gestiona pedidos.
- **Repartidor:** gestiona las entregas asignadas.
- **Central:** coordina y supervisa las operaciones del sistema.

## 4. Funcionalidades

### Funcionalidades actuales

- Inicio de sesión con Supabase Auth.
- Creación automática del perfil mediante trigger.
- Identificación del rol del usuario.
- Dashboards independientes por rol.
- Consulta de restaurantes desde Supabase.
- Diseño responsive inicial.

### Funcionalidades en desarrollo

- Catálogo de productos.
- Carrito de compras.
- Creación y seguimiento de pedidos.
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
| Abstract Factory | MenuFactory y sus fábricas concretas generan familias de productos, como platos y bebidas, según el tipo de menú. |
| Prototype | PedidoPrototype permite clonar pedidos anteriores para facilitar la repetición de pedidos. |

### 5.2. Patrones estructurales

Se utilizan para organizar las relaciones entre objetos y facilitar la comunicación entre diferentes componentes del sistema.

| Patrón | Aplicación en QueueGo |
|---|---|
| Adapter | PlatoProductoAdapter y BebidaProductoAdapter adaptan los objetos Plato y Bebida al modelo Producto utilizado por el carrito. |
| Decorator | PlatoDecorator permite agregar extras a los platos, como queso adicional, tocineta o salsas, modificando dinámicamente su descripción y precio. |
| Facade | CheckoutFacade proporciona una interfaz unificada para coordinar la validación del carrito, conversión de productos, generación del identificador y creación del pedido. |

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

**Nota:** las clases de los patrones estructurales están desarrolladas. La integración completa de Adapter y Decorator con el flujo de las pantallas, así como la conexión de Facade con el controlador de pedidos, debe completarse y verificarse para considerar los tres patrones plenamente integrados en la aplicación.

## 6. Arquitectura del proyecto

La arquitectura busca separar las responsabilidades y evitar que las pantallas dependan directamente de la lógica de acceso a datos.

```text
screens
   |
   v
repositories (interfaces)
   |
   v
services (implementaciones)
   |
   v
Supabase
```

Los modelos se mantienen separados de la lógica de acceso a datos. Los patrones de diseño complementan esta organización para facilitar la creación de objetos, la adaptación de componentes y la coordinación de procesos.

## 7. Base de datos

La estructura de datos contempla las siguientes tablas:

- `profiles`
- `restaurants`
- `products`
- `orders`
- `order_items`
- `deliveries`

## 8. Principios SOLID aplicados

- **SRP (Single Responsibility Principle):** separación de responsabilidades entre modelos, repositorios, servicios, pantallas y dashboards.
- **OCP (Open/Closed Principle):** organización de roles y módulos para facilitar la extensión del sistema sin modificar innecesariamente los componentes existentes.
- **DIP (Dependency Inversion Principle):** la interfaz de usuario trabaja contra abstracciones como `AuthRepository` y `RestaurantRepository`.
- **ISP (Interface Segregation Principle):** utilización de interfaces pequeñas y específicas según las responsabilidades de cada componente.
- **LSP (Liskov Substitution Principle):** se procura que las implementaciones puedan utilizarse respetando los contratos definidos por sus abstracciones.

## 9. Refactorización y control de cambios

Los principales cambios realizados durante el desarrollo incluyen:

1. Separación de responsabilidades.
2. Sustitución de la autenticación local de demostración por Supabase Auth.
3. Modelado de roles mediante `UserRole`.
4. Separación de dashboards por rol.
5. Abstracción del acceso a datos mediante repositorios.
6. Implementación de servicios concretos para Supabase.
7. Incorporación de patrones creacionales para organizar la creación de objetos.
8. Incorporación de patrones estructurales para facilitar la relación y comunicación entre componentes.
9. Organización de los patrones en carpetas independientes.
10. Documentación de la arquitectura y los diagramas UML.

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
