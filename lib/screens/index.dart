import 'package:flutter/material.dart';
import '../widgets/botonera.dart';
import 'package:gato/config/config.dart';
import 'package:flutter/services.dart'; // Import this
import 'dart:io' show exit, Platform; // Import this

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return {'Reiniciar', 'Salir'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'X: ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    TextSpan(
                      text: '$winsX | ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'O: ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '$winsO | Empates: $ties',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Center(child: Image.asset('lib/resources/imagenes/board.png')),
                  Center(child: Botonera(onGameOver: _updateScore)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _showConfirmationDialog('Salir', _exitApp),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _showConfirmationDialog('Reiniciar todo', _restartGame),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => _showConfirmationDialog('reiniciar el juego actual', _startNewGame),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(String choice) {
    if (choice == 'Reiniciar') {
      _showConfirmationDialog('Reiniciar', _restartGame);
    } else if (choice == 'Salir') {
      _showConfirmationDialog('Salir', _exitApp);
    }
  }

  void _showConfirmationDialog(String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Deseas $action?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      resetGame();
      winsX = 0;
      winsO = 0;
      ties = 0;
    });
  }

  void _startNewGame() {
    setState(() {
      resetGame();
    });
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isWindows) {
      exit(0);
    }
  }

  void _updateScore() {
    setState(() {
      // This will refresh the scoreboard
    });
  }
}
