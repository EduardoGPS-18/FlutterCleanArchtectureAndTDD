import 'strings.dart';

class PtBr implements Translations {
  String get name => "Nome";
  String get email => "Email";
  String get login => "Entrar";
  String get password => "Senha";
  String get addAccount => "Criar conta";
  String get confirmPassword => "Confirme a senha";

  String get goToSignUp => "Cadastrar-se";
  String get goToLogin => "Já sou cadastrado!";

  String get invalidCredentials => "Credenciais inválidas";
  String get requiredField => "Campo obrigatório";
  String get emailInUse => "Email já está em uso";
  String get invalidField => "Campos inválidos";
  String get unexpected => "Erro inesperado";
}
