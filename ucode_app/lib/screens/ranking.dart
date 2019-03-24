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

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final _usernames = [
    "Sergio Bazán",
    "Diego Royo",
    "Gonzalo Bersé",
    "Adrian Samatán"
  ];
  final _icons = [
    Icon(MdiIcons.podiumGold),
    Icon(MdiIcons.podiumSilver),
    Icon(MdiIcons.podiumBronze),
    Icon(MdiIcons.dumbbell)
  ];

  final _tabStyle = TextStyle(color: Colors.grey, fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    Widget wRanking = ListView.builder(
      itemCount: _usernames.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return ListTile(
          leading: _icons[index],
          title: Text(_usernames[index]),
          subtitle: Text('Precisión: ${100 - index}%'),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
      ),
      body: SizedBox.expand(
        child: Column(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(double.infinity, 130.0),
              child: Stack(
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(double.infinity, 160.0),
                    child: Container(
                      color: Theme.of(context).primaryColor,
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
                  ),
                  Positioned(
                    bottom: 50,
                    left: 25,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Ranking',
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
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(
                          color: Theme.of(context).primaryColor,
                          child: TabBar(
                            tabs: [
                              Tab(text: 'Sergio Bazán'),
                              Tab(text: 'Leo Messi')
                            ],
                            indicatorColor: Colors.black,
                            labelStyle: _tabStyle,
                          ))),
                  body: TabBarView(children: <Widget>[wRanking, wRanking]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
