import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogo_da_memoria/models/carta.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<Carta> _cartas = [];
  var _caratasAgrupadas;
  bool _mostrandoErro = false;

  @override
  void initState() {
    _criaListaCartas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _criaGridCartas();
  }

  Widget _criaGridCartas() {
    return GridView.count(
      crossAxisCount: 4,
      children: _criaItensGrid(),
    );
  }

  void _criaListaCartas() {
    this._cartas = [
      Carta(
          id: 1,
          grupo: 1,
          color: Colors.red,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 2,
          grupo: 1,
          color: Colors.red,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 3,
          grupo: 2,
          color: Colors.amber,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 4,
          grupo: 2,
          color: Colors.amber,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 5,
          grupo: 3,
          color: Colors.blue,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 6,
          grupo: 3,
          color: Colors.blue,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 7,
          grupo: 4,
          color: Colors.green,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 8,
          grupo: 4,
          color: Colors.green,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 9,
          grupo: 5,
          color: Colors.purple,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 10,
          grupo: 5,
          color: Colors.purple,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 11,
          grupo: 6,
          color: Colors.pink,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 12,
          grupo: 6,
          color: Colors.pink,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 13,
          grupo: 7,
          color: Colors.brown,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 14,
          grupo: 7,
          color: Colors.brown,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 15,
          grupo: 8,
          color: Colors.orange,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
      Carta(
          id: 16,
          grupo: 8,
          color: Colors.orange,
          image:
              'https://i.pinimg.com/564x/e4/34/2a/e4342a4e0e968344b75cf50cf1936c09.jpg'),
    ];
    this._cartas.shuffle();
  }

  List<Widget> _criaItensGrid() {
    return this._cartas.map((carta) => _criaCardCarta(carta)).toList();
  }

  Widget _criaCardCarta(Carta carta) {
    return GestureDetector(
      onTap:
          !carta.visivel && !_mostrandoErro ? () => _mostrarCarta(carta) : null,
      child: Card(
        color: carta.visivel ? carta.color : Colors.grey,
        child: _criaTextoCard(carta),
      ),
    );
  }

  Widget _criaTextoCard(Carta carta) {
    if (carta.visivel) {
      // return Text(
      //   carta.grupo.toString(),
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 23,
      //   ),
      // );
      return Image.network(
        carta.image,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(
        Icons.memory,
        color: Colors.white,
      );
    }
  }

  void _mostrarCarta(Carta carta) {
    setState(() {
      carta.visivel = !carta.visivel;
    });
    _validaAcerto();
  }

  void _validaAcerto() {
    List<Carta> listaCartasVisiveis = _getCartasVisiveis();
    if (listaCartasVisiveis.length >= 2) {
      _caratasAgrupadas = _getCartasAgrupadas(listaCartasVisiveis);
      List<Carta> cartasIcorretas = List<Carta>();
      _caratasAgrupadas.forEach((key, value) {
        if (value.length < 2) {
          cartasIcorretas.add(value[0]);
        }
      });

      if (cartasIcorretas.length >= 2) {
        _escondeCartasIcorretas(cartasIcorretas);
      }
    }
  }

  List<Carta> _getCartasVisiveis() {
    return this._cartas.where((Carta carta) => carta.visivel).toList();
  }

  Map<int, List<Carta>> _getCartasAgrupadas(List<Carta> cartas) {
    return groupBy(cartas, (Carta carta) => carta.grupo);
  }

  void _escondeCartasIcorretas(List<Carta> cartasIcorretas) {
    setState(() {
      _mostrandoErro = true;
    });
    Timer(Duration(seconds: 1), () {
      for (var i = 0; i < cartasIcorretas.length; i++) {
        setState(() {
          cartasIcorretas[i].visivel = false;
        });
      }
      setState(() {
        _mostrandoErro = false;
      });
    });
  }
}
