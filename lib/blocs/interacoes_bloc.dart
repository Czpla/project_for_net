import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:net_new/validators/profile_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InteracoesBloc extends BlocBase with ProfileValidators{

  String cep;
  String rua;
  String cidade;
  String estado;
  String numero;
  String bairro;

  String nome;
  String celular;
  String telefone;
  String email;
  String operadora;
  String valorgasto;
  String observacoes;
  File imagem;
  String imagemUrl;
  String userEmail;

  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outBirthday => _birthdayController.stream.transform(validateBirthday);
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<String> get outConfirmationPassword=> _confirmationPasswordController.stream.transform(validateConfirmationPassword);

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeBirthday => _birthdayController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmationPassword => _confirmationPasswordController.sink.add;

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _birthdayController = BehaviorSubject<String>();
  final _confirmationPasswordController = BehaviorSubject<String>();

  final _interacoesController = BehaviorSubject<List>();
  final _outController = BehaviorSubject<List>();
  final _loadingController = BehaviorSubject<bool>();
  final _outControllerReport = BehaviorSubject<List>();
  final _outControllerUsers = BehaviorSubject<Map>();

  Stream<List> get outInteracoes => _interacoesController.stream;
  Stream<List> get out => _outController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<List> get outReport => _outControllerReport.stream;
  Stream<Map> get outUsers => _outControllerUsers.stream;

  Map<String, Map<String, dynamic>> _interacoes = {};
  Map<String, dynamic> locations;
  Map<String, dynamic> informations;
  Map<String, dynamic> user;

  Firestore _firestore = Firestore.instance;

  final _outControllerCarriers = BehaviorSubject<Map<String, dynamic>> ();
  Stream<Map<String, dynamic>> get outCarriers => _outControllerCarriers.stream;

  final _outControllerSearch = BehaviorSubject<String>();
  Stream<String> get outSearch => _outControllerSearch.stream;
  String searchReport;

  void addCarriers() async {
    _firestore.collection("carrier").snapshots().listen((carriers){

      for(DocumentSnapshot d in carriers.documents){
        _outControllerCarriers.add(d.data);
      }
    });
  }

  void onChangedSearch(String search){
    searchReport = search;
    _outControllerSearch.add(search);
    if(search.trim().isEmpty){
      _outControllerReport.add(_interacoes.values.toList());
    } else {
      _outControllerReport.add(_filterReport(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filterReport(String search){
    List<Map<String, dynamic>> filteredUsers = List.from(_interacoes.values.toList());
    filteredUsers.retainWhere((user){
      return user["rua"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
  }


  List<Map<String, dynamic>> filter({String ceps, String numbers}){
    List<Map<String, dynamic>> filteredCeps = List.from(_interacoes.values.toList());
    filteredCeps.retainWhere((cep){
      return cep.containsValue(ceps);
    });

    _interacoesController.value = filteredCeps;

    List<Map<String, dynamic>> filteredNumbers = List.from(_interacoesController.value.toList());
    filteredNumbers.retainWhere((number){
      return number.containsValue(numbers);
    });

    _outController.add(filteredNumbers);


    return filteredNumbers;
  }

  void userLog(){
    FirebaseAuth.instance.currentUser().then((d) async {
      userEmail = d.email;
      String userId = d.uid;

      _firestore.collection("users").document(userId).snapshots().listen((users){

        _outControllerUsers.add({"email" : userEmail, "name" : users.data["name"], "photoUrl" : users.data["photoUrl"], "birthday" : users.data["birthday"], "uid" : userId});

      });
    });
  }

  void addEntriesListener(){
    _firestore.collection("entries").snapshots().listen((snapshot){
      snapshot.documents.forEach((change) async {

          String uidUser = change.data["uidUser"];
          String uid = change.documentID;

             _firestore.collection("users").document(uidUser).snapshots().listen((name) async {
               _interacoes[uid].addAll({"email" : userEmail, "nameUser" : name.data["name"], "photoUrl" : name.data["photoUrl"], "birthday" : name.data["birthday"]});

          });

          _interacoes[uid] = change.data;

        _firestore.collection("entries").document(uid).collection("location").snapshots()
        .listen((locations) async {

          String cep = "";
          String number = "";
          String rua = "";
          String cidade = "";
          String estado = "";
          String bairro = "";

          for(DocumentSnapshot d in locations.documents){
            DocumentSnapshot location = await _firestore
                .collection("entries").document(uid).collection("location")
                .document(d.documentID).get();
            if(location.data == null) continue;
            cep = location.data["cep"];
            number = location.data["number"];
            rua = location.data["street"];
            cidade = location.data["city"];
            estado = location.data["state"];
            bairro = location.data["neighborhood"];
          }

          _interacoes[uid].addAll(
            {"cep" : cep, "number" : number, "rua" : rua, "cidade" : cidade, "estado" : estado, "bairro" : bairro });

        _outControllerReport.add(_interacoes.values.toList());

        });

        _firestore.collection("entries").document(uid).collection("information").snapshots()
            .listen((informations) async {

          String name = "";
          String phone = "";
          String carrier = "";
          String email = "";
          String observation = "";
          String value = "";
          String cellphone = "";
          String url = "";


          for(DocumentSnapshot d in informations.documents){
            DocumentSnapshot information = await _firestore
                .collection("entries").document(uid).collection("information")
                .document(d.documentID).get();
            if(information.data == null) continue;
            name = information.data["name"];
            phone = information.data["phone"];
            carrier = information.data["carrier"];
            email = information.data["e-mail"];
            observation = information.data["observation"];
            value = information.data["value"];
            cellphone = information.data["cellphone"];
            url = information.data["url"];

          }

          _interacoes[uid].addAll(
              {"name" : name, "phone" : phone, "carrier" : carrier,
              "e-mail" : email, "observation" : observation, "value" : value, "cellphone" : cellphone, "url" : url});
            });
      });

    });

  }


  InteracoesBloc({this.cep, this.numero, this.estado, this.cidade, this.bairro, this.rua}){
    locations = {"cep" : cep, "number" : numero, "state" : estado, "city" : cidade, "street" : rua, "neighborhood" : bairro};
    addEntriesListener();
    userLog();
    addCarriers();
  }

  getLocation(String nome, String celular, String telefone, String email, String operadora, String valorgasto, String observacoes, File img) {
    if(operadora == null){
      operadora = "";
    }
    informations = {"name" : nome, "cellphone" : celular, "phone" : telefone, "e-mail" : email, "carrier" : operadora, "value" : valorgasto, "observation" : observacoes,};

    imagem = img;
  }

  Future<bool> saveInteraction() async {
    _loadingController.add(true);
    try {
      FirebaseAuth.instance.currentUser().then((d){
        String uid = d.uid;

        Firestore.instance.collection("users").document(uid).snapshots().listen((name) async {

          DateTime today = new DateTime.now();
          String date ="${today.day.toString().padLeft(2,'0')}/"
              "${today.month.toString().padLeft(2,'0')}/"
              "${today.year.toString()}";

          String time
          ="${today.hour.toString().padLeft(2,"0")}:${today.minute.toString().padLeft(2,'0')}";

          Map<String, dynamic> first = {"uidUser" : uid, "date" : date, "time" : time,};

          String id = DateTime.now().toString();

          await Firestore.instance.collection("entries").document(id).
          setData(first).then((location) async {

            await Firestore.instance.collection("entries").document(id).collection("location").add(locations);

            if(informations != null){
              if(imagem != null){await _uploadImages(id);}
              else {informations.addAll({"url" : ""});}
              await Firestore.instance.collection("entries").document(id).collection("information").add(informations);
            }

          });
        });
      });
      _loadingController.add(false);
      return true;
    } catch (e){
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String informationUid) async {
    StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(informationUid).putFile(imagem);

    StorageTaskSnapshot s = await uploadTask.onComplete;
    String downloadUrl = await s.ref.getDownloadURL();

    informations.addAll({"url" : downloadUrl});
  }

  @override
  void dispose() {
    _nameController.close();
    _birthdayController.close();
    _emailController.close();
    _passwordController.close();
    _confirmationPasswordController.close();
    _interacoesController.close();
    _outController.close();
    _loadingController.close();
    _outControllerReport.close();
    _outControllerUsers.close();
    _outControllerSearch.close();
    _outControllerCarriers.close();
  }

}