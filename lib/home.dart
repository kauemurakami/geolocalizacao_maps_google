import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quiver/core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  Set<Polygon> _poligonos = {};
  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);

  }

  _carregarPolygons(){
    Set<Polygon> poligonosLocal = {};

    Polygon polygon1 = Polygon(
      polygonId: PolygonId("poligon1"),
      fillColor: Colors.transparent,
        strokeColor: Colors.purpleAccent,
      strokeWidth: 5,
      points: [
        LatLng(-19.867909, -47.441241),
        LatLng(-19.872288, -47.439267),
        LatLng(-19.870725, -47.442743)
      ],
      consumeTapEvents: true,
      onTap: (){
        print("clicado na area denotada");
      }
    );

    poligonosLocal.add(polygon1);
    setState(() {
      _poligonos = poligonosLocal;
    });
  }
  _carregarMarcadores(){

    Set<Marker> marcadoresLocal = {};
    Marker marcadorRodoviaria = Marker(
      markerId: MarkerId("rodoviaria"),
      position: LatLng(-19.869766, -47.441681),
      infoWindow: InfoWindow(
        title: "Rodoviária de Sacramento"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue
      ),
      rotation: 25,
      onTap: (){
        print("clicado rodoviaria");
      },
    );
    Marker marcadorFarmacia = Marker(
        markerId: MarkerId("farmacia"),
        position: LatLng(-19.870422, -47.441660),
      infoWindow: InfoWindow(
        title: "Farmácia Canastra"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueCyan
      ),
      rotation: 10,
      onTap: (){
        print("clicado farmacia");
      },
    );

    marcadoresLocal.add(marcadorRodoviaria);
    marcadoresLocal.add(marcadorFarmacia);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  _movimentarCamera() async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-19.869776, -47.441702),
          zoom: 19,
          tilt: 0, //inclinaçao
          bearing: 30 //rotação
        )
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _carregarPolygons();
    _carregarMarcadores();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(-19.869120, -47.441681),
            zoom: 15
          ),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _poligonos,
        ),
      ),
    );
  }
}
