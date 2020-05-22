import 'package:flutter/material.dart';
import 'package:net_new/blocs/login_bloc.dart';
import 'package:net_new/widgets/input_field.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {

    super.initState();
    _loginBloc.outState.listen((state) async {
      if(context != null){
        switch(state){
          case LoginState.SUCCESS:
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context)=>HomeScreen())
            );
            break;
          case LoginState.FAIL:
            showDialog(context: context, builder: (context)=> AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              title: Text("Erro"),
              content: Text("Falha ao fazer login, você não tem permisão para acessar o aplicativo, contate seu administrador."),
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
          case LoginState.LOADING:
          case LoginState.IDLE:
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch(snapshot.data){
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );
            case LoginState.IDLE:
            case LoginState.SUCCESS:
            case LoginState.FAIL:
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(Icons.store_mall_directory,
                              color: Colors.blue,
                              size: 160.0,
                            ),
                            InputField(
                              icon: Icons.person_outline,
                              hint: "Usuário",
                              obscure: false,
                              stream: _loginBloc.outEmail,
                              onChanged: _loginBloc.changeEmail,
                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 12.0,),
                            InputField(
                              icon: Icons.https,
                              hint: "Senha",
                              obscure: true,
                              stream: _loginBloc.outPassword,
                              onChanged: _loginBloc.changePassword,
                            ),
                            SizedBox(height: 55.0,),
                            StreamBuilder<bool>(
                                stream: _loginBloc.onSubmitValid,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    height: 50.0,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0)
                                      ),
                                      color: Colors.blue,
                                      child: Text("Entrar", style: TextStyle(fontSize: 17.0),),
                                      textColor: Colors.white,
                                      onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                      disabledColor: Colors.blue.withAlpha(140),
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return null;
        }
      ),
    );
  }
}
