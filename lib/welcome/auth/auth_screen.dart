import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/welcome/auth/auth_bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Petinder/common/common.dart';
import 'package:Petinder/registration_pet/utils/custom_dialog_box.dart';
import 'package:Petinder/welcome/utils/large_button.dart';
import 'package:hive/hive.dart';
import 'auth_bloc/auth_bloc.dart';
import 'auth_bloc/auth_event.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Container(
                width: double.infinity,
                child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, authState) async {
                  if (!authState.errorLogin && authState.isCorrect) {
                    await handleLocation(context);
                  } else if (authState.errorLogin && !authState.isCorrect) {
                    showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "Błąd autoryzacji",
                                descriptions: authState.error.isNotEmpty
                                    ? authState.error
                                    : "Podczas autoryzacji wystąpił błąd, spróbuj ponownie.",
                                text: "Ok",
                              );
                            })
                        .whenComplete(() => {
                              context
                                  .read<AuthBloc>()
                                  .add(ErrorDialogClickedEvent())
                            });
                  }
                }, builder: (context, authState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        authState.isLogin
                            ? 'Zaloguj się do'
                            : 'Zarejestruj się do',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 35,
                        ),
                      ),
                      Text(
                        'Petindera',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text('Podaj poniżej swoje dane ',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 14,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      formField("Adres e-mail", authState, context),
                      formField("Hasło", authState, context),
                      !authState.isLogin
                          ? formField("Powtórz hasło", authState, context)
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          String errors =
                              decideWhatIsEmpty(authState, authState.isLogin);
                          if (errors.isNotEmpty) {
                            showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String type = authState.isLogin
                                          ? "Logowania"
                                          : "Rejestracji";
                                      return CustomDialogBox(
                                        title: "Błąd $type",
                                        descriptions: "Uzupełnij: $errors",
                                        text: "Ok",
                                      );
                                    })
                                .whenComplete(() => {
                                      context
                                          .read<AuthBloc>()
                                          .add(ErrorDialogClickedEvent())
                                    });
                          } else {
                            context.read<AuthBloc>().add(AuthClickedEvent());
                          }
                        },
                        child: LargeButton(
                          showIcon: false,
                          borderColor: Color(0xff4F5563),
                          buttonText: authState.isLogin
                              ? 'Zaloguj się'
                              : 'Zarejestruj się',
                          fillColor: Color(0xff4F5563),
                          buttonTextColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          authState.isLogin
                              ? Navigator.of(context)
                                  .pushNamed(RouteConstant.registerScreen)
                              : Navigator.of(context)
                                  .pushNamed(RouteConstant.loginScreen);
                        },
                        child: Text(
                          authState.isLogin
                              ? "Nie masz konta? Zarejestruj się"
                              : "Masz konto? Zaloguj się",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff0C8EFF),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                })),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        color: Color(0xff4F5563),
        icon: SvgPicture.asset(
          'images/ios-back.svg',
          width: 90,
          height: 90,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

String decideWhatIsEmpty(AuthState authState, bool isLogin) {
  String emptySteps = "";
  if (authState.email.isEmpty) {
    emptySteps += Common.addComaIfNotEmpty(emptySteps);
    emptySteps += "e-mail";
  }
  if (authState.password.isEmpty) {
    emptySteps += Common.addComaIfNotEmpty(emptySteps);
    emptySteps += "hasło";
  }
  if (!isLogin) {
    if (authState.passwordRE.isEmpty) {
      emptySteps += Common.addComaIfNotEmpty(emptySteps);
      emptySteps += "powtórzone hasło";
    }
  }
  return emptySteps;
}

String decideText(String text) {
  if (text == "Adres e-mail") {
    return "Wpisz swój adres e-mail";
  } else if (text == "Hasło") {
    return "Podaj swoje hasło";
  } else {
    return "Powtórz hasło";
  }
}

String decideInititalValue(String text, AuthState authState) {
  if (text == "Adres e-mail") {
    return authState.email;
  } else if (text == "Hasło") {
    return authState.password;
  } else {
    return authState.passwordRE;
  }
}

SvgPicture buildSvgPicture(String keyWord) {
  return keyWord != 'Adres e-mail'
      ? SvgPicture.asset('images/password.svg', fit: BoxFit.scaleDown)
      : SvgPicture.asset('images/email.svg', fit: BoxFit.scaleDown);
}

void saveQueryChanged(
    String category, String query, AuthState authState, BuildContext context) {
  if (category == "Adres e-mail") {
    context.read<AuthBloc>().add((EmailInsertedEvent(mail: query)));
  } else if (category == "Hasło") {
    context.read<AuthBloc>().add((PasswordInsertedEvent(password: query)));
  } else {
    context.read<AuthBloc>().add((PasswordREInsertedEvent(password: query)));
  }
}

Widget formField(String keyWord, AuthState authState, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              keyWord,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(1, 1),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(-1, -1),
                )
              ]),
          child: TextFormField(
            onChanged: (value) {
              saveQueryChanged(keyWord, value, authState, context);
            },
            initialValue: decideInititalValue(keyWord, authState),
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
            ),
            obscureText: keyWord != 'Adres e-mail',
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black38,
                  fontWeight: FontWeight.w400),
              hintText: decideText(keyWord),
              prefixIcon: buildSvgPicture(keyWord),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: buildOutlineInputBorder(Colors.white),
              border: buildOutlineInputBorder(Colors.white),
              focusedBorder: buildOutlineInputBorder(Color(0xff0C8EFF)),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> handleLocation(BuildContext context) async {
  Box locationBox = Hive.box("Location");
  bool newLocation = locationBox.get("newLocation");
  print("JAK $newLocation");
  bool firstTime = true;
  if (newLocation) {
    Hive.box("IsLogin").put("IsLogin", true);
    Navigator.pushNamed(context, RouteConstant.dashboard);
  } else {
    locationBox.watch()
      ..listen((event) {
        if (firstTime) {
          Hive.box("IsLogin").put("IsLogin", true);
          Navigator.pushNamed(context, RouteConstant.dashboard);
          firstTime = false;
        }
      });
  }
}

OutlineInputBorder buildOutlineInputBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: borderColor),
  );
}

void unfocusTextFields(context) {
  FocusScope.of(context).unfocus();
}
