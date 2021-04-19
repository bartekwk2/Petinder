import 'package:email_validator/email_validator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../auth_bloc/auth_event.dart';
import '../auth_bloc/auth_repository.dart';
import '../auth_bloc/auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({this.authRepository}) : super(AuthState.empty());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is PasswordInsertedEvent) {
      yield state.copyWith(
          password: event.password, isCorrect: false, errorLogin: false);
    } else if (event is PasswordREInsertedEvent) {
      yield state.copyWith(
          passwordRE: event.password, isCorrect: false, errorLogin: false);
    } else if (event is EmailInsertedEvent) {
      yield state.copyWith(
          email: event.mail, isCorrect: false, errorLogin: false);
    } else if (event is AuthClickedEvent) {
      if (state.isLogin) {
        yield* _performLogin(state);
      } else {
        yield* _performRegistration(state);
      }
    } else if (event is ErrorDialogClickedEvent) {
      yield state.copyWith(isCorrect: false, errorLogin: false);
    } else if (event is DecideIfLoginEvent) {
      yield state.copyWith(isLogin: event.isLogin,isCorrect: false, errorLogin: false);
    }
  }

  Stream<AuthState> _performRegistration(AuthState state) async* {
    if (state.passwordRE == state.password) {
      if (EmailValidator.validate(state.email)) {
        dynamic userID =
            await authRepository.registerUser(state.email, state.password);
        if (userID.isNotEmpty) {
          if (userID == "-1") {
            yield state.copyWith(
                isCorrect: false,
                errorLogin: true,
                error: "Użytkownik o podanym e-mailu już istnieje");
          } else {
            yield state.copyWith(isCorrect: true, errorLogin: false);
          }
        } else {
          yield state.copyWith(
              isCorrect: false,
              errorLogin: true,
              error: "Podczas logowania wystąpił problem. Spróbuj ponownie");
        }
      } else {
        yield state.copyWith(
            isCorrect: false,
            errorLogin: true,
            error: "Wprowadzono e-mail w nieprawidłowym formacie");
      }
    } else {
      yield state.copyWith(
          isCorrect: false,
          errorLogin: true,
          error: "Wprowadzono 2 różne hasła");
    }
  }

  Stream<AuthState> _performLogin(AuthState state) async* {
    dynamic userID =
        await authRepository.loginUser(state.email, state.password);
    if (userID.isNotEmpty) {
      yield state.copyWith(isCorrect: true, errorLogin: false);
    } else {
      yield state.copyWith(isCorrect: false, errorLogin: true);
    }
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    return AuthState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(AuthState state) {
    return state.toMap();
  }
}
