# Flutter Lifecycle Example

Este repositorio contiene una demostración práctica y detallada del ciclo de vida de un `StatefulWidget` en Flutter, instrumentada con logs claros para entender cada etapa del flujo.

Donde la aplicacion es basicamente el contador inicial de cualquier proyecto inicial de flutter pero expandido con instrumentación de logs en consola(usando logger ), carga asíncrona de un archivo JSON local en el initState, un servicio de audio que se libera correctamente en el dispose para evitar fugas de memoria, y una estructura entre un componente padre e hijo que permite evidenciar en tiempo real el funcionamiento de cada método del ciclo de vida

## ¿Qué encontrarás en este repositorio?

* **`main.dart` (El Padre)**: Configura la aplicación y actúa como contenedor principal. Incluye un contador que puede incrementarse de forma independiente y se pasa como parámetro hacia la pantalla de demostración para probar la actualización de propiedades.
* **`lifecycle_demo.dart` (El Hijo)**: El componente central donde se ejecutan y registran todos los métodos del ciclo de vida (`createState`, `initState`, `didChangeDependencies`, `didUpdateWidget`, `build`, `deactivate` y `dispose`).
* **Carga Asíncrona de JSON**: Dentro del método `initState`, se simula una espera mediante `Future.delayed` y se lee un archivo local `assets/data.json` utilizando `rootBundle`, controlando un indicador de carga (`CircularProgressIndicator`).
* **Gestión de Recursos (AudioPlayer)**: Se instancia un servicio de reproducción de audio (`audioplayers`) al nacer el componente y se destruye explícitamente llamando a `_audioPlayer.dispose()` en el método `dispose` para prevenir fugas de memoria (memory leaks).
* **Uso del logger**: Cada método del ciclo de vida cuenta con un registro detallado en la consola mediante el paquete `logger`, permitiendo ver el orden cronológico exacto de la ejecución mientras interactúas con la interfaz.