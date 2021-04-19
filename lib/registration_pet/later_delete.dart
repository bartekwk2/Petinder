import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ScreenTwo extends StatefulWidget {
  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  FocusNode _focusNode;
  FocusNode _focusNode2;
  stt.SpeechToText _speech;
  bool _isListening = false;
  double _confidence = 1.0;
  String _text = '';
    SfRangeValues _values = SfRangeValues(5.0, 15.0);
  double _value = 15.0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode2 = FocusNode();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _requestFocus2() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: Column(
          children: <Widget>[
                        Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.9,
              child: SfRangeSlider(
                activeColor: Color(0xff3289E2),
                min: 0.0,
                max: 25.0,
                values: _values,
                interval: 5,
                showTicks: true,
                labelFormatterCallback: (actualValue, formattedText) {
                  if (actualValue == 0) {
                    return '1-';
                  } else if (actualValue == 25) {
                    return '25+';
                  } else {
                    return formattedText;
                  }
                },
                tooltipTextFormatterCallback: (actualValue, formattedText) {
                  String value = (actualValue.toInt()).toString();
                  print(value);

                  if (value == '0') {
                    return '1-';
                  } else if (value == '25') {
                    return '25+';
                  } else {
                    return value;
                  }
                },
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _values = values;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 32,
            ),
            Center(
                child: Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      child: Center(
                          child: Column(children: [
                        TextFormField(
                          focusNode: _focusNode,
                          onTap: _requestFocus,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'images/dog-tag.svg',
                                width: 5,
                                height: 5,
                              ),
                            ),
                            labelText: "Wprowadź imię ",
                            labelStyle: _focusNode.hasFocus
                                ? TextStyle(color: Colors.black, fontSize: 16)
                                : TextStyle(
                                    color: Color(0xff7B7B7B), fontSize: 14),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xff286687)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Email cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLines: 10,
                          focusNode: _focusNode2,
                          onTap: _requestFocus2,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText:
                                !_focusNode2.hasFocus ? "Wprowadź opis" : "",
                            labelText:
                                _focusNode2.hasFocus ? "Wprowadź opis" : "",
                            labelStyle: _focusNode2.hasFocus
                                ? TextStyle(color: Colors.black, fontSize: 16)
                                : TextStyle(
                                    color: Color(0xff7B7B7B), fontSize: 14),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Color(0xff1A6D85)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Email cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ])),
                    )))
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}