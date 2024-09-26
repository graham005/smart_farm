// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  String? selectedCrop;
  String? selectedFertilizer;
  double acreage = 0;
  double seedAmount = 0;
  double fertilizerAmount = 0;

  final Map<String, double> seedRates = {
    'Maize' : 10,
    'Beans' : 24,
    'Groundnuts': 25,
    'Peas': 30,
  };
  final Map<String, double> fertilizerRates ={
    'DAP' : 75,
    'CAN' : 50,
    'UREA' : 50,
  };

  void calculate(){
    setState(() {
      seedAmount = (seedRates[selectedCrop] ?? 0 ) * acreage;
      fertilizerAmount = (fertilizerRates[selectedFertilizer] ?? 0) * acreage;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Farm Seed & Fertilizer Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4CAF50),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/farm_background2.jpg'),
            fit: BoxFit.cover,
          )
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Calculate Your Needs',
              style: TextStyle(fontSize:  24, fontWeight:  FontWeight.bold, color:  Colors.white),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: 'Acres',
                
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                filled:  true,
                fillColor:  Colors.green.shade800.withOpacity(0.5),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                acreage =double.tryParse(value) ?? 0 ;
              },
            ),
            SizedBox(height: 30),         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton(
                    hint: Text('Select Crop', style: TextStyle(color: Colors.white)),
                    value: selectedCrop,
                    dropdownColor: Colors.green.shade800,
                    items: seedRates.keys.map((crop){
                      return DropdownMenuItem(
                        value: crop,
                        child: Text(crop, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(), 
                    onChanged: (value){
                      setState(() {
                        selectedCrop =value;
                      });
                    }
                  ),
                ),
                SizedBox(width: 70),
                Expanded(
                  child: DropdownButton<String>(
                    hint:  Text('Select Fertilizer', style: TextStyle(color: Colors.white)),
                    value: selectedFertilizer,
                    dropdownColor: Colors.green.shade800,
                    items: fertilizerRates.keys.map((fertilizer){
                      return DropdownMenuItem(
                        value: fertilizer,
                        child: Text(fertilizer, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(), 
                    onChanged: (value) {
                      setState(() {
                        selectedFertilizer = value;
                      });
                    }
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 200),
            ElevatedButton(
              onPressed: calculate, 
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Calculate'),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      'Seed Amount: ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '${seedAmount.toStringAsFixed(2)} kg',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ]
                ),
                Column(
                  children: [
                    Text(
                      'fertilizerAmount: ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '${fertilizerAmount.toStringAsFixed(2)} kg',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                  ]
                ),
                
                SizedBox(height: 15),
                
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}