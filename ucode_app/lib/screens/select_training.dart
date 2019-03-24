import 'package:flutter/material.dart';
import 'package:ucode_app/screens/training.dart';
import 'package:ucode_app/util/connection.dart';
import 'package:ucode_app/models/sensor_data.dart';

class SelectTraining extends StatefulWidget {
  @override
  _SelectTrainingState createState() => _SelectTrainingState();
}

class _SelectTrainingState extends State<SelectTraining> {
  final _styleTitle = TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold);
  final _sujetoStyle = TextStyle(fontSize: 17.0, color: Colors.white);

  final _sujetos = <String>[
    "Sergio Bazán",
    "Leo Messi",
    "Gareth Bale",
    "Paul Pogba"
  ];

  final _videoNames = [
    ["tiro1.mp4", "tiro2.mp4"],
    ["pase1.mp4", "pase2.mp4"],
    ["tiro1.mp4", "pase1.mp4"]
  ];

  final _typeImages = <String>["shot.jpg", "pass.jpg", "other.jpg"];
  final _typeNames = <String>["Tiro", "Pase", "Otro"];
  final _typeVerbs = <String>["tirar", "pasar", "otro"];
  int _typeSelected = 0;

  void _selectPlayer(idSujeto, idTipo) async {
    print('Sujeto $idSujeto y tipo $idTipo');

    // Dialogo de cargando mientras se hace la peticion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cargando...'),
          content: Text(
              'Aprende a ${_typeVerbs[idTipo]} como ${_sujetos[idSujeto]}'),
        );
      },
    );

    // Crear el SensorData para mostrar al usuario
    await API.getTrainData(idSujeto, idTipo);
    SensorData receivedData = SensorData(
        idTipo: idTipo,
        idSujeto: idSujeto,
        tipo: _typeNames[idTipo],
        sujeto: _sujetos[idSujeto]);

    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Training(
              originalData: receivedData,
              videoNames: _videoNames[_typeSelected])),
    );
  }

  // Selecionar tipo de entrenamiento (pase, tiro, otro)
  void _selectType(id) {
    setState(() {
      _typeSelected = id;
    });
  }

  Widget _buildTypeButton(id) {
    return Expanded(
      child: RaisedButton(
        child: Text(
          _typeNames[id],
          style: TextStyle(
            color: _typeSelected == id ? Colors.white : Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: _typeSelected == id
            ? Theme.of(context).primaryColor
            : Colors.white70,
        onPressed: () {
          _selectType(id);
        },
      ),
    );
  }

  Widget _buildTypeButtons() {
    return Row(
      children: <Widget>[
        _buildTypeButton(0),
        _buildTypeButton(1),
        //_buildTypeButton(2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrenamiento'),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            new OverflowBox(
                minWidth: 0.0,
                minHeight: 0.0,
                maxWidth: double.infinity,
                child: new Image(
                  image: new AssetImage('images/${_typeImages[_typeSelected]}'),
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.srcOver,
                  color: new Color.fromARGB(210, 220, 220, 220),
                )),
            Container(
              margin: EdgeInsets.only(left: 15, top: 30, right: 15),
              child: Column(
                children: <Widget>[
                  Text('Selecciona entrenamiento...',
                      style: _styleTitle, textAlign: TextAlign.left),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: _buildTypeButtons(),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: _sujetos.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(_sujetos[index], style: _sujetoStyle),
                              onPressed: () {
                                _selectPlayer(index, _typeSelected);
                              },
                            );
                          })),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
