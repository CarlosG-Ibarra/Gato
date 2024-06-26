library config.globals;
import 'package:flutter/material.dart';

enum EstadosCelda { empty, circle, cross }

List<EstadosCelda> estados = List.filled(9, EstadosCelda.empty);

Map<EstadosCelda, bool> resultado = {
  EstadosCelda.cross: false,
  EstadosCelda.circle: false,
};

int winsX = 0;
int winsO = 0;
int ties = 0;

void resetCounts() {
  winsX = 0;
  winsO = 0;
  ties = 0;
}

void incrementWins(EstadosCelda winner) {
  if (winner == EstadosCelda.cross) {
    winsX++;
  } else if (winner == EstadosCelda.circle) {
    winsO++;
  }
}

void incrementTies() {
  ties++;
}

void resetGame() {
  estados = List.filled(9, EstadosCelda.empty);
  resultado[EstadosCelda.cross] = false;
  resultado[EstadosCelda.circle] = false;
}
