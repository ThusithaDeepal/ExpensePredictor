import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PredictionInput {
  static Widget predictionInputField(
      {String val, TextEditingController controller, Function inputvalidator}) {
    return (TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      maxLength: 5,
      decoration: InputDecoration(label: Text(val), counterText: ""),
      validator: inputvalidator,
    ));
  }
}
