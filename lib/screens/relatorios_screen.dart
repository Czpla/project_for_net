import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/widgets/card_report.dart';

class RelatorioScreen extends StatefulWidget {
  @override
  _RelatorioScreenState createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {

  final pesquisarController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final _interacoesBloc = BlocProvider.of<InteracoesBloc>(context);
    pesquisarController.text = _interacoesBloc.searchReport;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 28),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(

              enableInteractiveSelection: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText:  "Pesquisar",
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.search, color: Colors.white,),
                  border: InputBorder.none,
              ),
              onChanged: _interacoesBloc.onChangedSearch,
              controller: pesquisarController,
            ),
          ),
        ),
        Expanded(
            child: StreamBuilder<List>(
                stream: _interacoesBloc.outReport,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                    );
                  else if (snapshot.data.length == 0)
                    return Center(
                      child: Text("Nenhuma rua encontrada.", style: TextStyle(
                          color: Colors.black, fontSize: 16
                      ),),
                    );
                  else
                    return SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        itemBuilder: (context, index) {
                          return CardReport(snapshot.data[index]);
                        },
                        itemCount: snapshot.data.length,
                      ),
                    );
                }
            ),
          ),
      ],
    );
  }
}




