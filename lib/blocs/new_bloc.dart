import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:net_new/validators/new_valitators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:via_cep/via_cep.dart';

enum NewState {IDLE, LOADING, SUCCESS, FAIL}
class NewBloc extends BlocBase with NewValidators {

  final cepController = BehaviorSubject<String>();
  final ruaController = BehaviorSubject<String>();
  final bairroController = BehaviorSubject<String>();
  final cidadeController = BehaviorSubject<String>();
  final estadoController = BehaviorSubject<String>();
  final numeroController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<NewState>();

  Stream<String> get outCEP => cepController.stream.transform(validateCep);
  Stream<String> get outRua => ruaController.stream.transform(validateRua);
  Stream<String> get outBairro => bairroController.stream.transform(validateBairro);
  Stream<String> get outCidade => cidadeController.stream.transform(validateCidade);
  Stream<String> get outEstado => estadoController.stream.transform(validateEstado);
  Stream<String> get outNumero => numeroController.stream.transform(validateNumero);
  Stream<NewState> get outState => _stateController.stream;

  Stream<bool> get onSubmitValid => Observable.combineLatest6(
      outCEP, outRua, outBairro, outCidade, outEstado, outNumero, (a, b, c, d, e, f) => true
  );

  Function(String) get changeCEP => cepController.sink.add;
  Function(String) get changeRua => ruaController.sink.add;
  Function(String) get changeBairro => bairroController.sink.add;
  Function(String) get changeCidade => cidadeController.sink.add;
  Function(String) get changeEstado => estadoController.sink.add;
  Function(String) get changeNumero => numeroController.sink.add;

  StreamSubscription _streamSubscription;

  NewBloc(){
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user){
      if(user != null){
        _stateController.add(NewState.SUCCESS);
      } else {
        _stateController.add(NewState.IDLE);
      }
    });
  }

  void Clear(){
    _stateController.add(NewState.LOADING);
    ruaController.value = "";
    bairroController.value = "";
    cidadeController.value = "";
    estadoController.value = "";
    numeroController.value = "";
    _stateController.add(NewState.IDLE);
  }

  void clearNumber(){
    numeroController.value = "";
  }

  Future<Map> search() async {
    final cep = cepController.value.substring(0,9);
    var CEP = new via_cep();

    //final cep = cepController.value;

    _stateController.add(NewState.LOADING);

    var result = await CEP.searchCEP(cep, 'json', '');


    if (CEP.getResponse() == 200) {
      if(CEP.getUF() != null){
        ruaController.value = CEP.getLogradouro();
        cidadeController.value = CEP.getLocalidade();
        estadoController.value = CEP.getUF();
        bairroController.value = CEP.getBairro();
        _stateController.add(NewState.SUCCESS);
      } else {
        _stateController.add(NewState.FAIL);
        Clear();
      }
    } else {
      _stateController.add(NewState.FAIL);
      Clear();
    }
    return null;
  }

  @override
  void dispose() {
    cepController.close();
    bairroController.close();
    ruaController.close();
    cidadeController.close();
    estadoController.close();
    numeroController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }

}