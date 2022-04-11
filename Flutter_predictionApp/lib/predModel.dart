import 'package:flutter/material.dart';
import 'package:prediciton_model/common_widgets/predictionInput.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredModel extends StatefulWidget {
  @override
  _PredModelState createState() => _PredModelState();
}

class _PredModelState extends State<PredModel> {
  TextEditingController txtControllerD1 = TextEditingController();
  TextEditingController txtControllerD2 = TextEditingController();
  TextEditingController txtControllerD3 = TextEditingController();
  TextEditingController txtControllerD4 = TextEditingController();
  TextEditingController txtControllerD5 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var predValue = "";
  bool resetStatus = false;

  @override
  void initState() {
    super.initState();
    predValue = "click predict button";
  }

  Future<void> predData() async {
    //get input from form and predict the expense using tflite model
    try {
      resetStatus = false;
      if (_formKey.currentState.validate()) {
        final interpreter = await Interpreter.fromAsset('predmodel.tflite');

        var input = [
          [
            double.parse(txtControllerD1.text),
            double.parse(txtControllerD2.text),
            double.parse(txtControllerD3.text),
            double.parse(txtControllerD4.text),
            double.parse(txtControllerD5.text),
          ]
        ];
        var output = List.filled(1, 0).reshape([1, 1]);
        interpreter.run(input, output);

        this.setState(() {
          predValue = double.parse(output[0][0].toString()).toStringAsFixed(2);
        });
      }
    } catch (e) {}
  }

  // ignore: missing_return
  String fieldvalidator(txt) {
    if (!resetStatus) {
      if (txt.length < 1) {
        return "Required Field";
      } else {
        return null;
      }
    }
  }

  void resetData() {
    try {
      _formKey.currentState.reset();
      txtControllerD1.clear();
      txtControllerD2.clear();
      txtControllerD3.clear();
      txtControllerD4.clear();
      txtControllerD5.clear();

      resetStatus = true;
      setState(() {
        predValue = "click predict button";
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.attach_money),
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            "Expense Predictor",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/expense.png",
              ),
              Text(
                "Enter previous 5 days expenses to get next day expense prediction",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        PredictionInput.predictionInputField(
                            val: "1st Day expense",
                            controller: txtControllerD1,
                            inputvalidator: fieldvalidator),
                        PredictionInput.predictionInputField(
                            val: "2nd Day expense",
                            controller: txtControllerD2,
                            inputvalidator: fieldvalidator),
                        PredictionInput.predictionInputField(
                            val: "3rd Day expense",
                            controller: txtControllerD3,
                            inputvalidator: fieldvalidator),
                        PredictionInput.predictionInputField(
                            val: "4th Day expense",
                            controller: txtControllerD4,
                            inputvalidator: fieldvalidator),
                        PredictionInput.predictionInputField(
                            val: "5th Day expense",
                            controller: txtControllerD5,
                            inputvalidator: fieldvalidator),
                      ],
                    )),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.blue,
                    child: Text(
                      "predict",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: predData,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.blue,
                    child: Text(
                      "reset",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: resetData,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                "Predicted value :  $predValue ",
                style: TextStyle(color: Colors.red, fontSize: 23),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
