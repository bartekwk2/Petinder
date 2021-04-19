import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:Petinder/registration_pet/utils/custom_rect_tween.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPopupCard extends StatelessWidget {
  
  const TodoPopupCard({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationPetBloc, RegistrationPetState>(
        builder: (context, registrationState) {
        return Hero(
          tag: 'tag',
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 4.0,
                      ),
                    ]),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sczegóły szczepień",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              onChanged: (value) {
                                context.read<RegistrationPetBloc>().add(
                                    AddvaccinationDescEvent(
                                        vaccinationDesc: value));
                              },
                              initialValue: registrationState.vaccinationDesc,
                              maxLines: 8,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: ' Napisz więcej o szczepieniach pupila',
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
