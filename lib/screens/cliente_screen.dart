import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/screens/new_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'home_screen.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Im;
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:exif/exif.dart';

class ClienteScreen extends StatefulWidget {

  final String cep;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;
  final String numero;

  ClienteScreen({this.cep, this.rua, this.bairro, this.cidade, this.estado, this.numero});

  @override
  _ClienteScreenState createState() => _ClienteScreenState(cep, rua, bairro, cidade, estado, numero);
}

class _ClienteScreenState extends State<ClienteScreen> {

  File fileImage;

  var _celularController = MaskedTextController(mask: '(00) 00000-0000');
  var _telefoneController = MaskedTextController(mask: '(00) 0000-0000');
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _valorController = TextEditingController();
  final _observacoesController = TextEditingController();
  String dropdownValue;

  List<String> listDropValues = ['Net', 'Gvt', 'Oi', 'Copel', 'Claro', 'Meganet', 'Nenhuma'];

  final InteracoesBloc _interacoesBloc;


  _ClienteScreenState(String cep, String rua, String bairro, String cidade, String estado, String numero) :
        _interacoesBloc = InteracoesBloc(cep: cep, numero: numero, estado: estado, cidade: cidade, bairro: bairro, rua: rua);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                  foregroundDecoration: BoxDecoration(
                      color: Colors.black45
                  ),
                  height: 350,
                  width: double.infinity,
                  child: fileImage == null ? Icon(Icons.image, size: 250, color: Colors.blue,)
                      : Image.file(fileImage, fit: BoxFit.cover,)),
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 290),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        width: double.infinity,
                        height: 730.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  offset: Offset(0.0, 3.0),
                                  blurRadius: 15.0
                              )
                            ]
                        ),
                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text("Dados Pessoais",
                                    style: TextStyle(fontSize: 24.0,
                                        fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20.0,),
                                  _creatTextForm("Digite o Nome",
                                      "Nome",
                                      Icons.person,
                                      controller: _nomeController,
                                      error: "Insira o Nome"
                                  ),
                                  SizedBox(height: 20.0,),
                                  _creatTextForm("Digite o Celular",
                                      "Celular",
                                      Icons.phone_android,
                                      controller: _celularController,
                                      inputType: TextInputType.number
                                  ),
                                  SizedBox(height: 20.0,),
                                  _creatTextForm("Digite o Telefone",
                                      "Telefone",
                                      Icons.phone,
                                      controller: _telefoneController,
                                      inputType: TextInputType.number
                                  ),
                                  SizedBox(height: 20.0,),
                                  _creatTextForm("Digite o E-mail",
                                      "E-mail",
                                      Icons.email,
                                      controller: _emailController,
                                      inputType: TextInputType.emailAddress
                                  ),
                                  SizedBox(height: 20.0,),
                                  Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 11.0, right: 10.0),
                                            height: 59,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              border: Border.all(
                                                  color: Colors.blueAccent, style: BorderStyle.solid, width: 1.2),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.work,color: Colors.blueAccent,),
                                                SizedBox(width: 11.0,),
                                                Expanded(
                                                  child: DropdownButtonHideUnderline(
                                                    child: StreamBuilder<QuerySnapshot>(
                                                      stream: Firestore.instance.collection("carrier").snapshots(),
                                                      builder: (context, snapshot) {
                                                        if (!snapshot.hasData)
                                                          return Center(
                                                            child: Container(),
                                                          );
                                                        return DropdownButton(
                                                          isExpanded: true,
                                                          hint: Text("Operadora", style: TextStyle(color: Colors.blueAccent, fontSize: 15.5),),
                                                          icon: Icon(Icons.expand_more,size: 32.0, color: Colors.blueAccent,),
                                                          style: TextStyle(color: Colors.black,fontSize: 15.0),
                                                          value: dropdownValue,
                                                          onChanged: (String newValue) {
                                                            setState(() {
                                                              dropdownValue = newValue;
                                                            });
                                                          },
                                                          items: /*listDropValues
                                                              .map<DropdownMenuItem<String>>((String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text(value),
                                                            );
                                                          }).toList(),*/
                                                          snapshot.data.documents.map((DocumentSnapshot document) {
                                                            return DropdownMenuItem<String>(
                                                                value: document.data['carriers'],
                                                                child: new Container(
                                                                  decoration: new BoxDecoration(
                                                                      borderRadius: new BorderRadius.circular(5.0)
                                                                  ),
                                                                  //color: primaryColor,
                                                                  child: new Text(document.data['carriers']),
                                                                )
                                                            );
                                                          }).toList(),
                                                        );
                                                      },
                                                    )
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                  SizedBox(height: 20.0,),
                                  _creatTextForm("Digite o Valor Gasto",
                                      "Valor Gasto",
                                      Icons.monetization_on,
                                      controller: _valorController,
                                      inputType: TextInputType.number
                                  ),
                                  SizedBox(height: 20.0,),
                                  _creatTextForm("Digite a Observação",
                                      "Observações",
                                      Icons.lightbulb_outline,
                                      controller: _observacoesController,
                                  ),

                                  SizedBox(height: 40.0,),
                                  Row(
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
                                              _interacoesBloc.getLocation(_nomeController.text, _celularController.text, _telefoneController.text,
                                              _emailController.text, dropdownValue, _valorController.text, _observacoesController.text, fileImage);

                                              showDialog(barrierDismissible: false, context: context, builder: (context)=> AlertDialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                title: Center(child: CircularProgressIndicator()),
                                                content: Text("Salvando interação...", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
                                              ));
                                              bool success = await _interacoesBloc.saveInteraction();
                                              await Future.delayed(Duration(seconds: 12));
                                              Navigator.pop(context);

                                              showDialog(barrierDismissible: false, context: context, builder: (context)=> AlertDialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                title: Text(success ? "Interação salva com sucesso." : "Erro ao salvar interação.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                                                content: Text("Deseja cadastrar mais alguma casa nesse CEP?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("Sim"),
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text("Não"),
                                                    onPressed: (){
                                                      Navigator.pop(context);
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
                                            color: Colors.red,
                                            textColor: Colors.white,
                                            child: Text("Cancelar", style: TextStyle(fontSize: 16.0),),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 32.0
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(builder: (context)=>HomeScreen())
                                              );
                                            }
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(alignment: Alignment.topLeft,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              Positioned(
                top: 44.0,
                right: 12.0,
                child: GestureDetector(
                  child: Icon(Icons.camera_alt, color: Colors.white,),
                  onTap: () async {

                    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

                    if(imageFile != null && imageFile.path != null){

                      File imageRotate = await rotateAndCompressAndSaveImage(imageFile);

                      imageFile = await FlutterExifRotation.rotateImage(path: imageFile.path);
                      final tempDir = await getTemporaryDirectory();
                      final path = tempDir.path;
                      int rand = new Math.Random().nextInt(10000);

                      Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
                      Im.Image smallerImage = Im.copyResize(image, width: 350); // choose the size here, it will maintain aspect ratio

                      var compressedImage = new File('$path/img_$rand'+DateTime.now().millisecondsSinceEpoch.toString()+'.jpg')
                        ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 70),);
                      if(compressedImage != null){
                        setState(() {
                          fileImage = imageRotate;
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}



Future<File> rotateAndCompressAndSaveImage(File image) async {
  int rotate = 0;
  List<int> imageBytes = await image.readAsBytes();
  Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);

  if (exifData != null &&
      exifData.isNotEmpty &&
      exifData.containsKey("Image Orientation")) {
    IfdTag orientation = exifData["Image Orientation"];
    int orientationValue = orientation.values[0];

    print("Orientacao: " + orientationValue.toString());
    if(orientationValue == 0) {
      rotate = 90;
    }

    if (orientationValue == 3) {
      rotate = 180;
    }

    if (orientationValue == 6) {
      rotate = -90;
    }

    if (orientationValue == 8) {
      rotate = 90;
    }
  }

  List<int> result = await FlutterImageCompress.compressWithList(imageBytes,
      quality: 70, rotate: rotate, minWidth: 350);

  await image.writeAsBytes(result);

  return image;
}



Widget _creatTextForm(String hint, String label, IconData icon,{String error, TextInputType inputType,TextEditingController controller,} ){
  return TextFormField(
    decoration: InputDecoration(
      labelStyle: TextStyle(color: Colors.blueAccent),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
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
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(20.0)
      ),
      hintText: hint,
      labelText: label,
      prefixIcon: Icon (icon, color: Colors.blueAccent,),
    ),
    style: TextStyle(color: Colors.black),
    controller: controller,
    validator: (value){
      if (value.isEmpty){
        return error;
      }
      return null;
    },
    keyboardType: inputType,
  );
}
