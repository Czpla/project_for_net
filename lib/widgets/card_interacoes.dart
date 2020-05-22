import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CardInteracoes extends StatelessWidget {

  final Map<String, dynamic> snapshot;
  CardInteracoes(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 26,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[400]
            ),
            child: AspectRatio(
              aspectRatio: 1.7,
                child: snapshot["url"] != "" ? FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot["url"], fit: BoxFit.cover,)
                    : Icon(Icons.image, size: 150, color: Colors.blue,),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: snapshot["photoUrl"] != null ? NetworkImage(snapshot["photoUrl"],) :
                    NetworkImage("https://firebasestorage.googleapis.com/v0/b/net-telecom.appspot.com/o/IconPhotoUrlNull.png?alt=media&token=47097f64-c848-45fc-8653-8abe42b78d63"),
                  ),
                  margin: EdgeInsets.only(right: 16),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(snapshot["nameUser"], style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
                      SizedBox(height: 5,),
                      Text(snapshot["date"] +" às " + snapshot["time"])
                    ],
                  ),
                ),
              ],
            ),
          ),


          Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
              child: Column(
                  children: <Widget>[

                    if(snapshot["name"] != "") _creatRow("Nome: ", snapshot["name"]),

                    if(snapshot["cellphone"] != "") _creatRow("Celular: ", snapshot["cellphone"]),

                    if(snapshot["phone"] != "") _creatRow("Telefone: ", snapshot["phone"]),

                    if(snapshot["e-mail"] != "") _creatRow("E-mail: ", snapshot["e-mail"]),

                    if(snapshot["carrier"] != "") _creatRow("Operadora: ", snapshot["carrier"]),

                    if(snapshot["value"] != "") _creatRow("Valor gasto: ", snapshot["value"]),

                    if(snapshot["observation"] != "") _creatRow("Observações: ", snapshot["observation"]),
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
        Align(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
        Expanded(
            child: Text(context, style: TextStyle(fontSize: 13,), textAlign: TextAlign.start,)
        ),
        SizedBox(height: 20.0,),
      ],
  );
}
