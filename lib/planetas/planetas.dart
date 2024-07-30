//plain old dart object
class Planetas {
  int? id;
  String? nombre;
  double? distanciaSol;
  double? radio;

  Planetas(this.id, this.nombre, this.distanciaSol, this.radio);

  Planetas.deMapa(Map<String, dynamic> mapa) {
    id = mapa["id"];
    nombre = mapa["nombre"];
    distanciaSol = mapa["distanciaSol"];
    radio = mapa["radio"];
  }

  Map<String, dynamic> mapeador() {
    return {
      "id": id,
      "nombre": nombre,
      "distanciaSol": distanciaSol,
      "radio": radio
    };
  }
}
