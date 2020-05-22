import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class CardReport extends StatelessWidget {

  final Map<String, dynamic> report;

  CardReport(this.report);

  @override
  Widget build(BuildContext context) {
    if(report.containsKey("bairro") && report.containsKey("url"))
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        child: Card(
          elevation: 20,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[400]
                ),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: report["url"] != "" ? FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: report["url"] != null ? report["url"] : "", fit: BoxFit.cover,)
                      : Icon(Icons.image, size: 150, color: Colors.blue,),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 40,
                        backgroundImage: NetworkImage(report["photoUrl"]),
                      ),
                      margin: EdgeInsets.only(right: 16),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(report["nameUser"], style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
                          SizedBox(height: 5,),
                          Text(report["date"]+" às "+report["time"])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Endereço", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,)),
                    SizedBox(height: 10,),
                    _creatRow("Rua: ", report["rua"]),
                    _creatRow("Bairro: ", report["bairro"]),
                    _creatRow("Cidade: ", report["cidade"]),
                    _creatRow("Estado: ", report["estado"]),
                    _creatRow("Número: ", report["number"]),
                    _creatRow("CEP: ", report["cep"]),
                    if(report["name"] != "" || report["cellphone"] != "" || report["phone"] != "" || report["e-mail"] != "" || report["carrier"] != "" || report["value"] != "" || report["observation"] != "")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5,),
                          Divider(color: Colors.black,),
                          SizedBox(height: 5,),
                          Text("Dados pessoais", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,)),
                          SizedBox(height: 10,),
                          if(report["name"] != "") _creatRow("Nome: ", report["name"]),
                          if(report["cellphone"] != "") _creatRow("Celular: ", report["cellphone"]),
                          if(report["phone"] != "") _creatRow("Telefone: ", report["phone"]),
                          if(report["e-mail"] != "") _creatRow("E-mail: ", report["e-mail"]),
                          if(report["carrier"] != "") _creatRow("Operadora: ", report["carrier"]),
                          if(report["value"] != "") _creatRow("Valor gasto: ", report["value"]),
                          if(report["observation"] != "") _creatRow("Observações: ", report["observation"]),
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
     else
      return Card(
        elevation: 20,
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 230,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.black.withAlpha(50),
                  ),
                  baseColor: Colors.black,
                  highlightColor: Colors.white.withAlpha(200)
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 130,
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withAlpha(50),
                              radius: 40,
                            ),
                            baseColor: Colors.black,
                            highlightColor: Colors.white.withAlpha(200)
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Shimmer.fromColors(
                                child: Container(

                                  color: Colors.grey,
                                  width: 200,
                                  height: 20,
                                ),
                                baseColor: Colors.grey,
                                highlightColor: Colors.white.withAlpha(200)
                            ),
                            SizedBox(height: 20,),
                            Shimmer.fromColors(
                                child: Container(
                                  color: Colors.grey,
                                  width: 100,
                                  height: 10,
                                ),
                                baseColor: Colors.grey,
                                highlightColor: Colors.white.withAlpha(200)
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: double.infinity,
              height: 220,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 100,
                        height: 15,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 30,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 250,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 180,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 200,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 250,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 220,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 270,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                  SizedBox(height: 15,),
                  Shimmer.fromColors(
                      child: Container(
                        color: Colors.grey,
                        width: 250,
                        height: 10,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white.withAlpha(200)
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
}


Widget _creatRow (String title, String context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Align(child: Text(title == null ? '' : title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
      Expanded(
          child: Text(context == null ? '' : context, style: TextStyle(fontSize: 13,), textAlign: TextAlign.start,)
      ),
      SizedBox(height: 20.0,),
    ],
  );
}
