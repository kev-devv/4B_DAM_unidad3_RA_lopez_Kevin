# Kindo móvil

Prototipo de pantallas de la práctica de Desarrollo de Aplicaciones Móviles.
Abre directamente en Inicio. El catálogo, el perfil y la actividad se consultan
en la base de datos local SQLite `kindo_cliente.db`.

## Estructura del proyecto

```text
lib/
  main.dart
  estilo.dart
  modelo/
    bd.dart
    datos_iniciales.dart
    cliente.dart
    servicio.dart
    prestador.dart
    actividad.dart
  vista/
    appbar.dart
    item_servicio.dart
    item_prestador.dart
    item_actividad.dart
    view_inicio.dart
    view_explorar.dart
    view_actividad.dart
    view_perfil.dart
    view_acceso.dart
    view_detalle_servicio.dart
    view_detalle_prestador.dart
    view_detalle_actividad.dart
```

- `main.dart`: arranque, rutas, menú lateral y cuatro pestañas.
- `estilo.dart`: colores, textos y botón compartido.
- `modelo/`: conexión SQLite y modelos que convierten filas en objetos.
- `vista/`: pantallas y componentes reutilizables para las listas.

## Cómo recorrerlo

Usar las pestañas Inicio, Explorar, Actividad y Perfil. También se puede deslizar.
Desde Inicio se puede abrir Explorar y cada sección de Actividad. Al tocar una tarjeta
se abre su detalle con Navigator.push y MaterialPageRoute. Se regresa con la flecha.
Explorar permite alternar las listas completas de servicios y prestadores mediante pestañas.
La búsqueda, categoría y ordenamiento se muestran solo como campos de diseño de solo lectura.
Actividad consulta los registros del cliente local y los muestra por tipo.
Inicio usa esos registros para calcular los totales.
El menú lateral permite abrir la pantalla de acceso únicamente para ver el diseño.

## Base de datos local

`BD.conexion()` abre SQLite y crea las tablas de clientes, prestadores, servicios
y actividades. La creación carga los datos de ejemplo una sola vez. Si existe una
base vacía de la versión 1, la actualización carga los mismos datos. Las bases
que ya tienen registros conservan su contenido.

Como en `proyecto4b`, se pasa la conexión a los modelos para consultar los datos
y las vistas esperan el resultado con `FutureBuilder`. Hasta que haya acceso con
sesión, se usa el cliente con el primer identificador para Perfil y Actividad.

## Lo que todavía no está implementado

El acceso no valida datos, no crea sesiones y su botón está desactivado.
Cerrar sesión también está desactivado. La base es local. Quedan pendientes
el servidor, las compras, los envíos y las notificaciones del dispositivo.

## Conceptos utilizados

La interfaz utiliza StatelessWidget, StatefulWidget,
setState, listas, for, if, Column, Row, Expanded, ListView.builder, ListTile,
DefaultTabController, TabBar, TabBarView, Drawer y Navigator.
Los campos TextField de Explorar son estáticos y no tienen acciones asociadas.
No se usan búsqueda, filtros, ordenamiento ni menús de selección.
El código incluye comentarios explicativos.

En esta versión los detalles son pantallas con Navigator, en lugar de paneles
inferiores. El reporte y sus wireframes deberán actualizarse para reflejarlo antes
de entregar. El acceso seguirá siendo una maqueta hasta la siguiente etapa.

## Recursos

Las dos imágenes están en assets/imagenes y registradas en pubspec.yaml.
Si se copia únicamente lib a otro proyecto, también se necesitan esos recursos
para mostrar las imágenes. Consultar el formato permitido por el docente.

## Ejecutar y comprobar

Desde esta carpeta:

```powershell
flutter run
flutter analyze
flutter test
```
