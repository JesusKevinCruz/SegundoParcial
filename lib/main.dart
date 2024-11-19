import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppEstado createState() => _MyAppEstado();
}

class _MyAppEstado extends State<MyApp> {
  bool _esModoOscuro = false;

  void _cambiarTema(bool valor) {
    setState(() {
      _esModoOscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _esModoOscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: PantallaPrincipal(cambiarTema: _cambiarTema),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  final Function(bool) cambiarTema;

  const PantallaPrincipal({required this.cambiarTema});

  // Función para navegar a diferentes pantallas
  void _navegarAScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segundo Parcial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () =>
                  _navegarAScreen(context, const PantallaConversionDeNumeros()),
              child: const Text('Conversión de Números'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _navegarAScreen(context, const PantallaConversorDeMoneda()),
              child: const Text('Conversor de Moneda'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _navegarAScreen(context, const PantallaNumeroPrimo()),
              child: const Text('Verificar Número Primo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navegarAScreen(
                  context, PantallaCambioDeTema(cambiarTema: cambiarTema)),
              child: const Text('Cambiar Tema'),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaConversionDeNumeros extends StatefulWidget {
  const PantallaConversionDeNumeros({super.key});
  @override
  _PantallaConversionDeNumerosEstado createState() =>
      _PantallaConversionDeNumerosEstado();
}

class _PantallaConversionDeNumerosEstado
    extends State<PantallaConversionDeNumeros> {
  final TextEditingController _controlador = TextEditingController();
  String _resultado = '';

  void _convertir() {
    int numero = int.tryParse(_controlador.text) ?? 0;
    setState(() {
      _resultado = 'Binario: ${numero.toRadixString(2)}\n'
          'Octal: ${numero.toRadixString(8)}\n'
          'Hexadecimal: ${numero.toRadixString(16)}\n'
          'Decimal: $numero.0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversión de Números'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controlador,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa un número',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertir,
              child: const Text('Convertir'),
            ),
            const SizedBox(height: 20),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaConversorDeMoneda extends StatefulWidget {
  const PantallaConversorDeMoneda({super.key});
  @override
  _PantallaConversorDeMonedaEstado createState() =>
      _PantallaConversorDeMonedaEstado();
}

class _PantallaConversorDeMonedaEstado
    extends State<PantallaConversorDeMoneda> {
  final TextEditingController _controlador = TextEditingController();
  String _resultado = '';
  String _monedaOrigen = 'BOB';
  String _monedaDestino = 'USD';

  final Map<String, Map<String, double>> _tasasDeCambio = {
    'BOB': {
      'USD': 0.15,
      'BOB': 1.0,
    },
    'USD': {
      'BOB': 6.88,
      'USD': 1.0,
    },
  };

  void _convertirMoneda() {
    double cantidad = double.tryParse(_controlador.text) ?? 0.0;
    double cantidadConvertida = 0.0;

    if (_tasasDeCambio[_monedaOrigen]?.containsKey(_monedaDestino) == true) {
      double tasa = _tasasDeCambio[_monedaOrigen]![_monedaDestino]!;
      cantidadConvertida = cantidad * tasa;
    }

    setState(() {
      _resultado =
          'Resultado: ${cantidadConvertida.toStringAsFixed(2)} $_monedaDestino';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moneda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controlador,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Cantidad a convertir',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('De: '),
                DropdownButton<String>(
                  value: _monedaOrigen,
                  items: <String>['BOB', 'USD']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? nuevoValor) {
                    setState(() {
                      _monedaOrigen = nuevoValor!;
                    });
                  },
                ),
                const Text(' A: '),
                DropdownButton<String>(
                  value: _monedaDestino,
                  items: <String>['BOB', 'USD']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? nuevoValor) {
                    setState(() {
                      _monedaDestino = nuevoValor!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertirMoneda,
              child: const Text('Convertir'),
            ),
            const SizedBox(height: 20),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaNumeroPrimo extends StatefulWidget {
  const PantallaNumeroPrimo({super.key});
  @override
  _PantallaNumeroPrimoEstado createState() => _PantallaNumeroPrimoEstado();
}

class _PantallaNumeroPrimoEstado extends State<PantallaNumeroPrimo> {
  final TextEditingController _controlador = TextEditingController();
  String _resultado = '';

  bool _esPrimo(int numero) {
    if (numero <= 1) {
      return false;
    }
    for (int i = 2; i <= numero / 2; i++) {
      if (numero % i == 0) {
        return false;
      }
    }
    return true;
  }

  void _verificarPrimo() {
    int numero = int.tryParse(_controlador.text) ?? 0;
    if (numero < 0) {
      setState(() {
        _resultado = 'Por favor, ingrese un número positivo';
      });
    } else {
      setState(() {
        if (_esPrimo(numero)) {
          _resultado = 'El número $numero es primo';
        } else {
          _resultado = 'El número $numero no es primo';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Número Primo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controlador,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingrese un número',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verificarPrimo,
              child: const Text('Verificar'),
            ),
            const SizedBox(height: 20),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaCambioDeTema extends StatefulWidget {
  final Function(bool) cambiarTema;

  const PantallaCambioDeTema({required this.cambiarTema});

  @override
  _PantallaCambioDeTemaEstado createState() => _PantallaCambioDeTemaEstado();
}

class _PantallaCambioDeTemaEstado extends State<PantallaCambioDeTema> {
  bool _esModoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Tema'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Cambiar entre Modo Claro y Modo Oscuro:',
              style: TextStyle(fontSize: 20),
            ),
            Switch(
              value: _esModoOscuro,
              onChanged: (bool valor) {
                setState(() {
                  _esModoOscuro = valor;
                });
                widget.cambiarTema(valor);
              },
            ),
            Text(
              _esModoOscuro ? 'Modo Oscuro' : 'Modo Claro',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
