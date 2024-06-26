import 'package:flutter/material.dart';
import 'package:gato/config/config.dart';
import 'package:gato/widgets/celda.dart';
import 'package:flutter/services.dart'; // Import this
import 'dart:io' show exit, Platform; // Import this

class Botonera extends StatefulWidget {
  final VoidCallback onGameOver;

  const Botonera({super.key, required this.onGameOver});

  @override
  _BotoneraState createState() => _BotoneraState();
}

class _BotoneraState extends State<Botonera> {
  EstadosCelda estadoInicial = EstadosCelda.cross;

  @override
  Widget build(BuildContext context) {
    double dimension = MediaQuery.of(context).size.width;
    double ancho = dimension / 3;

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          children: [
            for (int row = 0; row < 3; row++)
              Expanded(
                child: Row(
                  children: [
                    for (int col = 0; col < 3; col++)
                      Expanded(
                        child: Celda(
                          ancho: ancho,
                          alto: ancho,
                          estado: estados[row * 3 + col],
                          callback: () => onPress(row * 3 + col),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onPress(int index) {
    debugPrint("Clicked: $index");

    if (estados[index] == EstadosCelda.empty) {
      setState(() {
        estados[index] = estadoInicial;
      });
      estadoInicial = estadoInicial == EstadosCelda.cross
          ? EstadosCelda.circle
          : EstadosCelda.cross;

      // Check if game is over
      if (isGameOver()) {
        EstadosCelda ganador = buscarGanador();
        _updateScores(ganador);
        showGameOverDialog(context, ganador);
        widget.onGameOver();
      }
    }
  }

  void _updateScores(EstadosCelda winner) {
    if (winner == EstadosCelda.cross) {
      winsX++;
    } else if (winner == EstadosCelda.circle) {
      winsO++;
    } else {
      ties++;
    }
  }

  bool isGameOver() {
    EstadosCelda ganador = buscarGanador();
    if (ganador != EstadosCelda.empty) {
      return true;
    }

    bool tie = estados.every((estado) => estado != EstadosCelda.empty);
    if (tie) {
      return true;
    }

    return false;
  }

  EstadosCelda buscarGanador() {
    for (int i = 0; i < estados.length; i += 3) {
      if (sonIguales(i, i + 1, i + 2)) {
        return estados[i];
      }
    }
    for (int i = 0; i < 3; i++) {
      if (sonIguales(i, i + 3, i + 6)) {
        return estados[i];
      }
    }
    if (sonIguales(0, 4, 8)) {
      return estados[0];
    }
    if (sonIguales(2, 4, 6)) {
      return estados[2];
    }

    return EstadosCelda.empty;
  }

  bool sonIguales(int a, int b, int c) {
    if (estados[a] != EstadosCelda.empty) {
      if (estados[a] == estados[b] && estados[b] == estados[c]) {
        resultado[estados[a]] = true;
        return true;
      }
    }
    return false;
  }

  void showGameOverDialog(BuildContext context, EstadosCelda winner) {
    String message = '';
    if (winner == EstadosCelda.cross) {
      message = '¡Felicidades! Ganaron las X.';
    } else if (winner == EstadosCelda.circle) {
      message = '¡Felicidades! Ganaron los O.';
    } else {
      message = '¡Empate!';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Juego Terminado'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame(); // Restart the game
              },
              child: Text('Continuar'),
            ),
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isWindows) {
                  exit(0);
                }// Close app
              },
              child: Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      estados = List.filled(9, EstadosCelda.empty);
      resultado[EstadosCelda.cross] = false;
      resultado[EstadosCelda.circle] = false;
      estadoInicial = EstadosCelda.cross;
    });
  }
}
