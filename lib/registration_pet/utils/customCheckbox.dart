import 'package:Petinder/registration_pet/registrationBloc/registration_pet_bloc.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_event.dart';
import 'package:Petinder/registration_pet/registrationBloc/registration_pet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCheckbox extends StatefulWidget {
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final int index;
  final RegistrationPetState state;

  CustomCheckbox(
      {this.state,
      this.size,
      this.iconSize,
      this.selectedColor,
      this.index,
      this.selectedIconColor});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected;

  @override
  Widget build(BuildContext context) {
    _isSelected = _decideWhichCheckbox(widget.index, widget.state);
    return GestureDetector(
      onTap: () {
        _sendCheckboxEvent(widget.index, widget.state);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: _isSelected
                ? widget.selectedColor ?? Colors.blue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            border: _isSelected
                ? null
                : Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  )),
        width: widget.size ?? 30,
        height: widget.size ?? 30,
        child: _isSelected
            ? Icon(
                Icons.check,
                color: widget.selectedIconColor ?? Colors.white,
                size: widget.iconSize ?? 20,
              )
            : null,
      ),
    );
  }

  bool _decideWhichCheckbox(int index, RegistrationPetState state) {
    if (index == 0) {
      return state.vaccinationFirst;
    } else if (index == 1) {
      return state.vaccinationSecond;
    } else {
      return state.vaccinationThird;
    }
  }

  void _sendCheckboxEvent(int index, RegistrationPetState state) {
    if (index == 0) {
      context
          .read<RegistrationPetBloc>()
          .add(MarkVaccinationFirstEvent(isMarked: !state.vaccinationFirst));
    } else if (index == 1) {
      context
          .read<RegistrationPetBloc>()
          .add(MarkVaccinationSecondEvent(isMarked: !state.vaccinationSecond));
    } else {
      context
          .read<RegistrationPetBloc>()
          .add(MarkVaccinationThirdEvent(isMarked: !state.vaccinationThird));
    }
  }
}
