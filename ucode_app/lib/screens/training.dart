import 'package:flutter/material.dart';
import 'package:ucode_app/util/connection.dart';
import 'package:ucode_app/models/sensor_data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Training extends StatefulWidget {
  final SensorData originalData;
  final List<String> videoNames;

  Training({Key key, @required this.originalData, this.videoNames})
      : super(key: key);

  @override
  _TrainingState createState() => _TrainingState(originalData, videoNames);
}

class _TrainingState extends State<Training> {
  // Informacion de mi tiro
  double _porcentaje = 0.0;
  int _potencia;
  List<dynamic> _comentarios = [];
  final _iconList = [
    Icon(Icons.thumb_down, color: Colors.red),
    Icon(Icons.thumb_up, color: Colors.green),
  ];

  final _textStyle = TextStyle(fontSize: 20.0);

  final SensorData _originalData;
  final List<String> _videoNames;
  int _videoSelected = 0;

  VideoPlayerController _controller;

  _TrainingState(this._originalData, this._videoNames);

  void _refrescar() async {
    // Mostrar dialogo mientras carga
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enviando datos...'),
        );
      },
    );

    API.compareData(_originalData.idSujeto, _originalData.idTipo).then((json) {
      Navigator.of(context).pop();
      setState(() {
        _porcentaje = json['pct'];
        _comentarios = json['msgs'];
        _potencia = json['pot'];
      });
    });

  }

  void _cambiarVista(id) {
    _controller = VideoPlayerController.asset('images/${_videoNames[id]}')
      ..initialize()
      ..play().then((_) {
        setState(() {
          _videoSelected = id;
        });
      });
  }

  Color _getProgressBarColor(percent) {
    if (percent < 40) {
      return Colors.red;
    } else if (percent < 60) {
      return Colors.yellow;
    } else if (percent < 80) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  Widget _buildCamera(id) {
    Color textColor =
        _videoSelected == id ? Colors.white : Theme.of(context).primaryColor;
    return Expanded(
      child: RaisedButton(
        color: _videoSelected == id
            ? Theme.of(context).primaryColor
            : Colors.white70,
        child: Text('Camara ${id + 1}', style: TextStyle(color: textColor)),
        onPressed: () {
          _cambiarVista(id);
        },
      ),
    );
  }

  Widget _buildCameraList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          _buildCamera(0),
          _buildCamera(1),
        ],
      ),
    );
  }

  List<Widget> _buildComentarios() {
    List<Widget> _comList = [];
    for (var i = 0; i < _comentarios.length; i++) {
      _comList.add(ListTile(
        leading: _iconList[_comentarios[i][1]],
        title: Text(_comentarios[i][0]),
      ));
    }
    return _comList;
  }

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('images/${_videoNames[_videoSelected]}')
          ..initialize()
          ..play().then((_) {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('${_originalData.tipo} de ${_originalData.sujeto}')),
      body: ListView(
        children: <Widget>[
          SizedBox.fromSize(
            size: Size(double.infinity, 240.0),
            child: Stack(
              children: <Widget>[
                VideoPlayer(_controller),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: RaisedButton(
                    color: Colors.white,
                    child:
                        Icon(Icons.sync, color: Theme.of(context).primaryColor),
                    onPressed: _refrescar,
                  ),
                ),
                _buildCameraList(),
              ],
            ),
          ),
          SizedBox.fromSize(
            size: Size(double.infinity, 60.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.only(left: 50),
                    width: MediaQuery.of(context).size.width - 50,
                    animation: true,
                    lineHeight: 30.0,
                    animationDuration: 2000,
                    percent: _porcentaje,
                    center: Text(
                        _porcentaje == 0.0
                            ? "Esperando datos..."
                            : "${(_porcentaje * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: _getProgressBarColor(_porcentaje * 100),
                  ),
                ),
              ],
            ),
          ),
          Column(children: _buildComentarios()),
          _potencia != null
          ? Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Center(
                child: CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: _potencia / 10.0,
                  header: new Text("Potencia de disparo", style: _textStyle),
                  center: new Icon(
                    MdiIcons.gauge,
                    size: 40.0,
                    color: Colors.green,
                  ),
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.green,
                ),
              ),
            )
          : Container(
            margin: EdgeInsets.only(top: 15),
            child: Center(child: Text('Esperando datos...', style:_textStyle))
          )
        ],
      ),
    );
  }
}
