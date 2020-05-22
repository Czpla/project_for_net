import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/widgets/image_source_sheet.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String urlPhoto = "https://firebasestorage.googleapis.com/v0/b/net-telecom.appspot.com/o/Eduardo_Czpla.png?alt=media&token=c153c678-fd35-41ec-9b41-6ca64f3e5e63";

  File profileImage;

  final _interacoesBloc = InteracoesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check, color: Colors.white,),
            onPressed: () {

            },
          ),
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
          else return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 180,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                borderRadius: BorderRadius.circular(70),
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                      builder: (context) => ImageSourceSheet(
                                        onImageSelected: (image) {
                                          setState(() {
                                            profileImage = image;
                                            Navigator.pop(context);
                                          });
                                        },
                                      ));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                  radius: 70,
                                  backgroundImage: profileImage != null ? FileImage(profileImage) : NetworkImage(urlPhoto),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                      builder: (context) => ImageSourceSheet(
                                        onImageSelected: (image) {
                                          setState(() {
                                            profileImage = image;
                                            Navigator.pop(context);
                                          });
                                        },
                                      ));
                                },
                                child: Text("Editar Foto", style: TextStyle(color: Colors.blue, fontSize: 23, fontWeight: FontWeight.w500),),
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 20,),
                    Form(
                      child: Column(
                        children: <Widget>[
                          customTextFormField(
                            stream: _interacoesBloc.outName,
                            obscure: false,
                            hintText: "Digite seu nome",
                            labelText: "Nome",
                            onchange: _interacoesBloc.changeName
                          ),
                          customTextFormField(
                            inputType: TextInputType.number,
                            onchange: _interacoesBloc.changeBirthday,
                            stream: _interacoesBloc.outBirthday,
                            obscure: false,
                            hintText: "Digite seu nascimento",
                            labelText: "Nascimento",
                          ),
                          customTextFormField(
                            inputType: TextInputType.emailAddress,
                            onchange: _interacoesBloc.changeEmail,
                            stream: _interacoesBloc.outEmail,
                            obscure: false,
                            hintText: "Digite seu E-mail",
                            labelText: "E-mail",
                          ),
                          customTextFormField(
                            onchange: _interacoesBloc.changePassword,
                            stream: _interacoesBloc.outPassword,
                            obscure: true,
                            hintText: "Digite sua senha",
                            labelText: "Senha",
                          ),
                          customTextFormField(
                            onchange: _interacoesBloc.changeConfirmationPassword,
                            stream: _interacoesBloc.outConfirmationPassword,
                            obscure: true,
                            hintText: "Digite sua senha",
                            labelText: "Confirme sua senha",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }
      )
    );
  }
}

Widget customTextFormField({MaskedTextController controller, TextInputType inputType, bool obscure, String hintText, String labelText, Function(String) onchange, Stream<String> stream}) {
  return StreamBuilder(
    stream: stream,
    builder: (context, snapshot){
      return TextFormField(
        onChanged: onchange,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(
              color: Colors.grey[600]
          ),
          labelStyle: TextStyle(
              color: Colors.grey[600]
          ),
          errorText: snapshot.hasError ? snapshot.error : null,
        ),
        keyboardType: inputType,
        controller: controller
      );
    },
  );
}
