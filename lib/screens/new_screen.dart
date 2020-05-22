import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/blocs/new_bloc.dart';
import 'package:net_new/screens/interacoes_screen.dart';
import 'package:net_new/widgets/field_decoration.dart';

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {

  final _newBloc = NewBloc();

  var cepController = MaskedTextController(mask: '00000-000');
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final numeroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newBloc.outState.listen((state){
      switch(state){
        case NewState.SUCCESS:
          break;
        case NewState.FAIL:
          showDialog(context: context, builder: (context)=> AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text("CEP não encontrado"),
            content: Text("Se o problema persistir digite manualmente o endereço."),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ));
          break;
        case NewState.LOADING:
        case NewState.IDLE:
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final _interacoesBloc = BlocProvider.of<InteracoesBloc>(context);

    _interacoes(){
      _interacoesBloc.filter(ceps: cepController.text, numbers: numeroController.text);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => InteracoesScreen(
                 cep: cepController.text,
                 numero: numeroController.text,
                 cidade: cidadeController.text,
                 bairro: bairroController.text,
                 rua: ruaController.text,
                 estado: estadoController.text,
              )
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Endereço"),
        elevation: 0.0,
        actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    _newBloc.Clear();
                  },
                  child: Text("Limpar",style: TextStyle(color: Colors.white,),)
              )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 90.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: TextField(
                                        controller: cepController,
                                        onChanged: _newBloc.changeCEP,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: Colors.red),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white),
                                              borderRadius: BorderRadius.circular(20.0)
                                          ),
                                          hintText: "CEP",
                                          hintStyle: TextStyle(color: Colors.white),
                                          labelText: "Digite o CEP",
                                          prefixIcon: Icon (Icons.location_on, color: Colors.white,),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                      ),


                              ),
                              SizedBox(width: 12.0,),
                              StreamBuilder<String>(
                                stream: _newBloc.outCEP,
                                builder: (context, snapshot) {
                                  return IconButton(
                                    icon: Icon(Icons.search),color: Colors.white,
                                    tooltip: "Pesquisar",
                                    onPressed: snapshot.hasData ? _newBloc.search : null,
                                        disabledColor: Colors.white.withAlpha(140),
                                  );
                                }
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                StreamBuilder<NewState>(
                  stream: _newBloc.outState,
                  initialData: NewState.IDLE,
                  builder: (context, snapshot) {
                    switch(snapshot.data){
                      case NewState.LOADING:
                        return Container(
                          width: double.infinity,
                          height: 400.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                            ),
                          ),
                        );
                      case NewState.SUCCESS:
                      case NewState.FAIL:
                      case NewState.IDLE:

                        ruaController.text = _newBloc.ruaController.value;
                        cidadeController.text = _newBloc.cidadeController.value;
                        bairroController.text = _newBloc.bairroController.value;
                        estadoController.text = _newBloc.estadoController.value;
                        numeroController.text = _newBloc.numeroController.value;

                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            FieldDecoration(
                              hint: "Digite a Rua",
                              label: "Rua",
                              icon: Icons.linear_scale,
                              stream: _newBloc.outRua,
                              onChanged: _newBloc.changeRua,
                              controller: ruaController,
                            ),
                            SizedBox(height: 10.0,),
                            FieldDecoration(
                              hint: "Digite o Bairro",
                              label: "Bairro",
                              icon: Icons.beenhere,
                              stream: _newBloc.outBairro,
                              onChanged: _newBloc.changeBairro,
                              controller: bairroController,
                            ),
                            SizedBox(height: 10.0,),
                            FieldDecoration(
                              hint: "Digite a Cidade",
                              label: "Cidade",
                              icon: Icons.location_city,
                              stream: _newBloc.outCidade,
                              onChanged: _newBloc.changeCidade,
                              controller: cidadeController,
                            ),
                            SizedBox(height: 10.0,),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: FieldDecoration(
                                    hint: "Digite o Estado",
                                    label: "Estado",
                                    icon: Icons.assessment,
                                    stream: _newBloc.outEstado,
                                    onChanged: _newBloc.changeEstado,
                                    controller: estadoController,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Expanded(
                                  child: FieldDecoration(
                                    hint: "Digite o Nº",
                                    label: "Número",
                                    icon: Icons.label_important,
                                    onChanged: _newBloc.changeNumero,
                                    controller: numeroController,
                                    stream: _newBloc.outNumero,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 40.0,),
                            StreamBuilder<bool>(
                                stream: _newBloc.onSubmitValid,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        child: Text("Trabalhar", style: TextStyle(fontSize: 16.0),),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                            horizontal: 32.0
                                        ),
                                        onPressed: snapshot.hasData ? _interacoes : null,
                                        disabledColor: Colors.blue.withAlpha(170), disabledTextColor: Colors.white,
                                      )
                                  );
                                }
                            )
                          ],
                        ),
                      );
                    }
                    return null;
                  }
                )
              ],
            )
          )
    );
  }
}
