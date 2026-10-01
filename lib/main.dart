import 'package:flutter/material.dart';
import 'lifecycle_demo.dart';


//Resumen del funcionamiento:
// Este archivo (main.dart) actúa como el punto de entrada principal de la aplicación
// y la pantalla de inicio (Padre) donde su objetivo es gestionar un contador global 
// que se puede incrementar localmente y enviarlo como parámetro a la pantalla de 
// demostración del ciclo de vida, permitiendo también abrir dicha pantalla mediante navegación.



void main() {
  runApp(const MyApp());
}

//widger raiz que controla el tema y la pantalla iniclial 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifecycle Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeWrapper(),//pantalla principal que contiene el contador y el boton para abrir la pantalla de demo
    );
  }
}

//widget con estado que representa la pantalla de inicio o el contendor padre que contiene el contador y el boton para abrir la pantalla de demo
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _parentCounter = 0;

  //metodo para incrementar el contador del padre y redibujar la interfaz
  void _incrementParent() {
    setState(() {
      _parentCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contador Padre: $_parentCounter'), //muestra el valor del contador del padre
            ElevatedButton(
              onPressed: _incrementParent,//incrementa el contador del padre y redibuja la interfaz
              child: const Text('Incrementar y actualizar hijo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { // boton que al ser presionado abre la pantalla de demo del ciclo de vida y le pasa el valor del contador del padre :p
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LifecycleDemo(
                      parentValue: _parentCounter,
                    ),
                  ),
                );
              },
              child: const Text('Abrir Demo de Ciclo de Vida'),
            ),
          ],
        ),
      ),
    );
  }
}