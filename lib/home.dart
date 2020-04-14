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
  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);

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
        ),
      ),
    );
  }
}
