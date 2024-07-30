import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/db/database.dart';
import '../planetas/planetas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Planetas> planetario = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _distanciaSolController = TextEditingController();
  final TextEditingController _radioController = TextEditingController();
  int? _currentId;

  @override
  void initState() {
    super.initState();
    _cargarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planetas Programa'),
      ),
      body: Column(
        children: [
          _buildForm(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: _distanciaSolController,
            decoration: const InputDecoration(labelText: 'Distancia al Sol'),
          ),
          TextField(
            controller: _radioController,
            decoration: const InputDecoration(labelText: 'Radio'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: _currentId == null ? _agregarPlaneta : _actualizarPlaneta,
                child: Text(_currentId == null ? 'Agregar' : 'Actualizar'),
              ),
              if (_currentId != null)
                ElevatedButton(
                  onPressed: _cancelarEdicion,
                  child: const Text('Cancelar'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return planetario.isEmpty
        ? const Center(
      child: CircularProgressIndicator(
        color: Colors.blueGrey,
      ),
    )
        : ListView.builder(
      itemCount: planetario.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.blur_circular_rounded),
            title: Text("Nombre: ${planetario[index].nombre}"),
            subtitle: Text("Radio: ${planetario[index].radio}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _borrarPlaneta(planetario[index].id!),
            ),
            onTap: () => _editarPlaneta(planetario[index]),
          ),
        );
      },
    );
  }

  Future<void> _cargarPlanetas() async {
    planetario = await DB.consulta();
    setState(() {});
  }

  Future<void> _agregarPlaneta() async {
    if (_nombreController.text.isEmpty ||
        _distanciaSolController.text.isEmpty ||
        _radioController.text.isEmpty) return;

    final planeta = Planetas(
      null,
      _nombreController.text,
      double.parse(_distanciaSolController.text),
      double.parse(_radioController.text),
    );

    await DB.insertar(planeta);
    _limpiarFormulario();
    _cargarPlanetas();
  }

  Future<void> _actualizarPlaneta() async {
    if (_currentId == null) return;

    final planeta = Planetas(
      _currentId,
      _nombreController.text,
      double.parse(_distanciaSolController.text),
      double.parse(_radioController.text),
    );

    await DB.actualizar(planeta);
    _limpiarFormulario();
    _cargarPlanetas();
  }

  Future<void> _borrarPlaneta(int id) async {
    await DB.borrar(id);
    _cargarPlanetas();
  }

  void _editarPlaneta(Planetas planeta) {
    _currentId = planeta.id;
    _nombreController.text = planeta.nombre!;
    _distanciaSolController.text = planeta.distanciaSol.toString();
    _radioController.text = planeta.radio.toString();
    setState(() {});
  }

  void _cancelarEdicion() {
    _limpiarFormulario();
  }

  void _limpiarFormulario() {
    _currentId = null;
    _nombreController.clear();
    _distanciaSolController.clear();
    _radioController.clear();
    setState(() {});
  }
}
