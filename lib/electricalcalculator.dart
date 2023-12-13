import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricalCalc extends StatefulWidget {
  @override
  _ElectricalCalcState createState() => _ElectricalCalcState();
}

class _ElectricalCalcState extends State<ElectricalCalc> {
  final TextEditingController prevMonthController = TextEditingController();
  final TextEditingController currentMonthController = TextEditingController();
  String selectedRate = '0.095'; // Initial rate for Residential
  String totalAmount = '';
  double rate = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_prevMonth', prevMonthController.text);
    await prefs.setString('_currMonth', currentMonthController.text);
    await prefs.setString('_selectedRate', selectedRate);
    await prefs.setString('_totalAmount', totalAmount);
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prevMonthController.text = prefs.getString('_prevMonth') ?? '';
      currentMonthController.text = prefs.getString('_currMonth') ?? '';
      selectedRate = prefs.getString('_selectedRate') ?? '0.095';
      totalAmount = prefs.getString('_totalAmount') ?? '';
    });
  }

  void _calcChange() {
    if (prevMonthController.text.isNotEmpty && currentMonthController.text.isNotEmpty) {
      double prevKWh = double.parse(prevMonthController.text);
      double currentKWh = double.parse(currentMonthController.text);

      double totalKWh = currentKWh - prevKWh;
      double totalPrice = totalKWh * double.parse(selectedRate);

      setState(() {
        totalAmount = 'RM $totalPrice';
      });

      _saveData();
    } else {
      setState(() {
        totalAmount = 'N/A. Please enter the values';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Electrical Usage Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Previous Month Reading (kWh): '),
            TextField(
              controller: prevMonthController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('Current Month Reading (kWh): '),
            TextField(
              controller: currentMonthController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('Rate: '),
            Row(
              children: <Widget>[
                Radio(
                  value: '0.095',
                  groupValue: selectedRate,
                  onChanged: (value) {
                    setState(() {
                      selectedRate = value.toString();
                    });
                  },
                ),
                Text('Residential'),
                Radio(
                  value: '0.125',
                  groupValue: selectedRate,
                  onChanged: (value) {
                    setState(() {
                      selectedRate = value.toString();
                    });
                  },
                ),
                Text('Industrial'),
              ],
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _calcChange,
                child: Text('Calculate Charge and Save'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'RM: $totalAmount',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

