import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/blocs/new_bloc.dart';
import 'package:net_new/widgets/card_interacoes.dart';
import 'cliente_screen.dart';
import 'home_screen.dart';

class InteracoesScreen extends StatefulWidget{

  final String cep;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;
  final String numero;

  InteracoesScreen({this.cep, this.rua, this.bairro, this.cidade, this.estado, this.numero});

  @override
  _InteracoesScreenState createState() => _InteracoesScreenState(cep, rua, bairro, cidade, estado, numero);
}

class _InteracoesScreenState extends State<InteracoesScreen> {

  final InteracoesBloc _interacoesBloc;

  _InteracoesScreenState(String cep, String rua, String bairro, String cidade, String estado, String numero) :
        _interacoesBloc = InteracoesBloc(cep: cep, numero: numero, estado: estado, cidade: cidade, bairro: bairro, rua: rua);

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final _interacoesBloc = BlocProvider.of<InteracoesBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Interações"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          StreamBuilder<List>(
              stream: _interacoesBloc.out,
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);
                else if(snapshot.data.length == 0){
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: Center(child: Text("Nenhuma interação encontrada.", style: TextStyle(fontSize: 16.0),))),
                        _creatContainer(),
                      ],
                    ),
                  );
                }
                else
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              return Column(
                                children: <Widget>[
                                  CardInteracoes(snapshot.data[index]),
                                  SizedBox(height: 10,),
                                ],
                              );
                            },
                            reverse: true,
                            padding: EdgeInsets.all(14.0),
                            itemCount: snapshot.data.length,
                          ),
                        ),
                      ),
                      _creatContainer(),
                    ],
                  );
              }
          ),
        ],
      )
    );
  }
  _creatContainer(){
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("Salvar", style: TextStyle(fontSize: 16.0),),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0
                ),
                onPressed: () async {
                  showDialog(barrierDismissible: false, context: context, builder: (context)=> AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    title: Center(child: CircularProgressIndicator()),
                    content: Text("Salvando interação...", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
                  ));
                   await Future.delayed(Duration(seconds: 12));
                  bool success = await _interacoesBloc.saveInteraction();
                  Navigator.pop(context);

                  showDialog( barrierDismissible: false,context: context, builder: (context)=> AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    title: Text(success ? "Interação salva com sucesso." : "Erro ao salvar interação.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    content: Text("Deseja cadastrar mais alguma casa nesse CEP?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Sim"),
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("Não"),
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context)=>HomeScreen()));
                        },
                      )
                    ],
                  ));
                }
            ),
          ),
          SizedBox(width: 10.0,),
          Expanded(
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("Continuar", style: TextStyle(fontSize: 16.0),),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClienteScreen(cep: widget.cep, rua: widget.rua, bairro: widget.bairro, cidade: widget.cidade, estado: widget.estado, numero: widget.numero))
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

}