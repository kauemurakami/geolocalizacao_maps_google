import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(
    target : LatLng(-19.869821, -47.441606),
    zoom: 16
  );
  Set<Marker> _marcadores = {};
  Set<Polygon> _poligonos = {};
  Set<Polyline> _polylines = {};
  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);

  }

  _carregarPolilines(){
    Set<Polyline> polilinesLocal = {};
    Polyline polyline = Polyline(
      polylineId: PolylineId("linha1"),
      color: Colors.blue,
      width: 5,
      startCap: Cap.buttCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      points: [
        LatLng(-19.870371, -47.441606),
        LatLng(-19.870745, -47.442818),
        LatLng(-19.872258, -47.443322)
      ]
    );
    polilinesLocal.add(polyline);
    setState(() {
      _polylines = polilinesLocal;
    });
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
        _posicaoCamera
      )
    );
  }
  _recuperarLocalizacaoAtual() async{
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );
    setState(() {
      _posicaoCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17
      );
      _movimentarCamera();
    });
  }

  _adicionarListenerLocalizacao(){
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10
    );
    geolocator.getPositionStream(locationOptions)
        .listen(
          (Position position){
            setState(() {
              _posicaoCamera = CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 17
              );
              _movimentarCamera();
            });
          }
    );
  }

  _recuperarLocalParaEndereco() async{
      List<Placemark> listaEnderecos = await Geolocator().placemarkFromAddress(" Sacramento Rua Silva Jardim, 414");
      print(listaEnderecos.length.toString());
      if(listaEnderecos != null && listaEnderecos.length > 0){
        Placemark endereco = listaEnderecos[0];
        String resultado = "\n" +endereco.administrativeArea;
        resultado += "\n" +endereco.subAdministrativeArea;
        resultado += "\n" +endereco.locality;
        resultado += "\n" +endereco.subLocality;
        resultado += "\n" +endereco.country;
        resultado += "\n" +endereco.thoroughfare;
        resultado += "\n" +endereco.subThoroughfare;
        resultado += "\n" +endereco.isoCountryCode;
        resultado += "\n" +endereco.postalCode;

        print(resultado);
      }else {

      }
  }

  _recuperarLocalParaEnderecoParaLatLng() async{
    List<Placemark> listaEnderecos = await Geolocator().placemarkFromCoordinates(-19.869821, -47.441606);
    print(listaEnderecos.length.toString());
    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];
      String resultado = "\n" +endereco.administrativeArea;
      resultado += "\n" +endereco.subAdministrativeArea;
      resultado += "\n" +endereco.locality;
      resultado += "\n" +endereco.subLocality;
      resultado += "\n" +endereco.country;
      resultado += "\n" +endereco.thoroughfare;
      resultado += "\n" +endereco.subThoroughfare;
      resultado += "\n" +endereco.isoCountryCode;
      resultado += "\n" +endereco.postalCode;

      print(resultado);
    }else {

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //_carregarPolygons();
    //_carregarPolilines();
   // _recuperarLocalizacaoAtual();
    //_carregarMarcadores();
    //_adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    _recuperarLocalParaEnderecoParaLatLng();
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
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          //markers: _marcadores,
          //polygons: _poligonos,
          //polylines: _polylines,
        ),
      ),
    );
  }
}
