import 'dart:async';

class NewValidators {

  final validateCep = StreamTransformer<String, String>.fromHandlers(
      handleData: (cep, sink){
        if(cep.length > 8){
          sink.add(cep);
        } else {
          sink.addError("Insira um CEP válido");
        }
      }
  );

  final validateRua = StreamTransformer<String, String>.fromHandlers(
      handleData: (rua, sink){
        if(rua.length > 0){
          sink.add(rua);
        } else {
          sink.addError("A Rua é obrigatória");
        }
      }
  );

  final validateBairro = StreamTransformer<String, String>.fromHandlers(
      handleData: (bairro, sink){
        if(bairro.length > 0){
          sink.add(bairro);
        } else {
          sink.addError("O Bairro é obrigatório");
        }
      }
  );

  final validateCidade = StreamTransformer<String, String>.fromHandlers(
      handleData: (Cidade, sink){
        if(Cidade.length > 0){
          sink.add(Cidade);
        } else {
          sink.addError("A Cidade é obrigatória");
        }
      }
  );

  final validateEstado = StreamTransformer<String, String>.fromHandlers(
      handleData: (Estado, sink){
        if(Estado.length > 0){
          sink.add(Estado);
        } else {
          sink.addError("O Estado é obrigatório");
        }
      }
  );

  final validateNumero = StreamTransformer<String, String>.fromHandlers(
      handleData: (Numero, sink){
        if(Numero.length > 0){
          sink.add(Numero);
        } else {
          sink.addError("O Número é obrigatório");
        }
      }
  );

}