import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 25.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(double.infinity, 160.0),
              child: Stack(
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(double.infinity, 160.0),
                    child: ClipPath(
                      clipper: DiagonalClipper(),
                      child: Image.asset(
                        'images/frontpage.jpg',
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.srcOver,
                        color: new Color.fromARGB(180, 30, 80, 10),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 25,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'eTrainer',
                          style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox.fromSize(
              size: Size(double.infinity, 15.0),
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 7),
                child: Text('Entrenamientos pasados',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                    leading: Icon(MdiIcons.dumbbell),
                    title: Text('Entrenamiento de tiros'),
                    subtitle: Text('Hace ${index + 1} dias'),
                  );
                },
              ),
            ),
            SizedBox.fromSize(
              size: Size(double.infinity, 75.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child:RaisedButton(
                  child: Text('Ranking',
                      style: TextStyle(fontSize: 23.0, color: Colors.white)),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ranking');
                  },
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(double.infinity, 80.0),
              child: FlatButton(
                child: Text('Empezar entrenamiento',
                    style: TextStyle(fontSize: 23.0, color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed('/select-training');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
