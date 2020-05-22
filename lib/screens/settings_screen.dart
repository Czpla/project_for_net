import 'package:flutter/material.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/blocs/login_bloc.dart';
import 'package:net_new/screens/login_screen.dart';
import 'package:net_new/screens/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _loginBloc = LoginBloc();
  final _interacoesBloc = InteracoesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("Configurações"),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                _loginBloc.singOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Text("Sair",style: TextStyle(color: Colors.white, fontSize: 16),)
          )
        ],
      ),
      body: StreamBuilder<Map>(
        stream: _interacoesBloc.outUsers,
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
          );
          else
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 35.0, horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          radius: 60,
                          backgroundImage: NetworkImage(snapshot.data["photoUrl"]),
                        ),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Container(
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
                              SizedBox(height: 5,),
                              Text(snapshot.data["birthday"]),
                              SizedBox(height: 5,),
                              Text(snapshot.data["email"])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue[300]
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () {

                                },
                                child: Container(
                                    /*decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(120))),*/
                                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    height: 60,
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.settings, color: Colors.white,),
                                          SizedBox(width: 20,),
                                          Text("Perfil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Divider(color: Colors.white,),
                        ),
                        InkWell(
                          onTap: () {

                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    height: 60,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.receipt, color: Colors.white,),
                                        SizedBox(width: 20,),
                                        Text("Minhas interações", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),),
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Divider(color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
        }
      )
    );
  }
}
