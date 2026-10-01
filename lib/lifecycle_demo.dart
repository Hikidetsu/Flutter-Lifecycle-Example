import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:audioplayers/audioplayers.dart';




//Resumen funcionamiento:
// Esta aplicación demuestra el ciclo de vida de un StatefulWidget en Flutter.
// Al abrir la pantalla de demo, se crea el estado, se inicializa un reproductor 
// de audio y se leen datos asíncronos desde un archivo JSON local mostrando un cargando.
// Permite observar en consola el orden exacto de los métodos (createState, initState,
// build, didUpdateWidget, deactivate y dispose), y cómo se limpian los recursos 
// al salir para evitar fugas de memoria.



// Widget principal que recibe un valor numerico desde la pantalla padre
class LifecycleDemo extends StatefulWidget {
  final int parentValue;

  const LifecycleDemo({super.key, required this.parentValue});

  @override
  //instanciamos el logger para poder usarlo en el ciclo de vida del widget
  State<LifecycleDemo> createState() {
    final logger = Logger();
    // [1] Primer método que se ejecuta al instanciar el StatefulWidget
    logger.d('[1. createState] Creando estado del widget.');
    return _LifecycleDemoState();
  }
}

// Estado asociado al widget LifecycleDemo, donde se implementa la lógica y el ciclo de vida
class _LifecycleDemoState extends State<LifecycleDemo> {
  final Logger _logger = Logger();
  late AudioPlayer _audioPlayer; // Instancia del servicio de audio a liberar (no existe audio en si pero da la idea de como se liberan recursos)
  bool _isLoading = true;        // Controla si se muestra el indicador de carga
  String _jsonData = '';         // Almacenará el texto leído del JSON
  int _counter = 0;              // Contador interno de la pantalla

  @override
  void initState() {
    super.initState();
    // [2] Se ejecuta una sola vez cuando el widget nace en el arbol de widgets, ideal para inicializar servicios y cargar datos asíncronos
    _logger.d('[2. initState] Widget inicializado. Configurando servicios.');
    _initServices();
  }

  // Metodo asincrono auxiliar para simular carga de archivos y servicios
  Future<void> _initServices() async {
    _audioPlayer = AudioPlayer();
    _logger.d('[Servicio] AudioPlayer listo en memoria.');
    
    // Simulamos un retraso de red o procesamiento pesado(mostramos el loader)
    await Future.delayed(const Duration(seconds: 2));
    _logger.d('[Archivo] Leyendo assets/data.json.');
    
    // Lectura del archivo JSON local configurado en pubspec.yaml
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);

    // Verificamos si el widget sigue montado antes de actualizar el estado
    if (mounted) {
      setState(() {
        _jsonData = data['title'];
        _isLoading = false; // Ocultamos el loader
      });
      _logger.d('[setState] Datos cargados. Quitando indicador de carga.');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // [3] Se ejecuta después de initState o cuando cambian dependencias del widget (como el Theme)
    _logger.d('[3. didChangeDependencies] Dependencias o Theme cargados.');
  }

  @override
  void didUpdateWidget(covariant LifecycleDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    // [4] Se ejecuta si el widget padre cambia las propiedades (parentValue) enviadas a este widget
    _logger.d('[4. didUpdateWidget] Padre actualizó propiedades. Anterior: ${oldWidget.parentValue}, Nuevo: ${widget.parentValue}.');
  }

  @override
  void deactivate() {
    // [6] Se ejecuta cuando el widget es retirado temporalmente de la vista (por ejemplo cuando ocurre navegación hacia otra pantalla :p)
    _logger.d('[6. deactivate] Widget removido temporalmente del árbol.');
    super.deactivate();
  }

  @override
  void dispose() {
    // [7] Ultimo metodo del ciclo de vida: destruye el widget y libera memoria definitivamente
    _logger.d('[7. dispose] Widget destruido. Liberando AudioPlayer.');
    _audioPlayer.dispose(); // Cierra el servicio de audio para evitar fugas de memoria y liberar recursos
    super.dispose();
  }

  //  metodo para  incrementar el contador interno y redibujar la interfaz
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _logger.d('[Acción] Contador interno incrementado a: $_counter.');
  }

  @override
  Widget build(BuildContext context) {
    // [5] Se ejecuta cada vez que la interfaz necesita dibujarse o redibujarse (ej. mediante setState)
    _logger.d('[5. build] Construyendo interfaz gráfica.');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciclo de Vida'),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) // Muestra carga mientras lee el JSON
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('JSON: $_jsonData'),
                  const SizedBox(height: 10),
                  Text('Valor heredado del Padre: ${widget.parentValue}'),
                  const SizedBox(height: 20),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}