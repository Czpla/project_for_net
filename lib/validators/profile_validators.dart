import 'dart:async';

class ProfileValidators {

  final validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink){
        if(name.length > 1){
          sink.add(name);
        } else {
          sink.addError("Insira seu nome");
        }
      }
  );

  final validateBirthday = StreamTransformer<String, String>.fromHandlers(
      handleData: (birthday, sink){
        if(birthday.length == 8){
          sink.add(birthday);
        } else {
          sink.addError("Insira sua data de nascimento");
        }
      }
  );


  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink){
        if(email.contains("@")){
          sink.add(email);
        } else {
          sink.addError("Insira um e-mail válido");
        }
      }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if(password.length >= 6){
          sink.add(password);
        } else  {
          sink.addError("A senha deve conter pelo menos 6 caracteres");
        }
      }
  );

  final validateConfirmationPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (confirmationPassword, sink){
        if(confirmationPassword == confirmationPassword){
          sink.add(confirmationPassword);
        } else  {
          sink.addError("As senhas devem ser iguais");
        }
      }
  );

}