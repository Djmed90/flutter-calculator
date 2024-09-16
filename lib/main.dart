import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Darren\'s Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onPressed(String input) {
    setState(() {
      if (input == '=') {
        _calculateResult();
      } else if (input == 'C') {
        _clear();
      } else if (input == '²') {
        // Square the last number in the expression
        _squareNumber();
      } else if (input == '%') {
        // Modulo operation
        _expression += '%';
      } else {
        _expression += input;
      }
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  void _squareNumber() {
    try {
      // Parse the last number in the expression
      final lastNumberMatch = RegExp(r'(\d+)$').firstMatch(_expression);
      if (lastNumberMatch != null) {
        String lastNumber = lastNumberMatch.group(1)!;
        num squaredValue = pow(double.parse(lastNumber), 2);
        _expression = _expression.substring(0, _expression.length - lastNumber.length) + squaredValue.toString();
      }
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _calculateResult() {
    try {
      Expression exp = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      var evalResult = evaluator.eval(exp, {});
      setState(() {
        _result = '= $evalResult';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Button background color
          ),
          onPressed: () => _onPressed(label),
          child: Text(
            label,
            style: TextStyle(fontSize: 24, color: Colors.green[900]), // Dark green text
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      appBar: AppBar(
        title: Text('Darren\'s Calculator'),
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 32, color: Colors.green[900]),
                  ),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green[900]),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('/'),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('*'),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-'),
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('C'),
                  _buildButton('='),
                  _buildButton('+'),
                ],
              ),
              Row(
                children: [
                  _buildButton('²'), // Square button
                  _buildButton('%'), // Modulo button
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
