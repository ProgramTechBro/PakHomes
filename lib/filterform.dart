import 'package:flutter/material.dart';

class FilterForm extends StatefulWidget {
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  String? _selectedCity;
  String? _selectedAreaType;
  TextEditingController _projectTitleController = TextEditingController();
  TextEditingController _projectTypeController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  TextEditingController _minAreaController = TextEditingController();
  TextEditingController _maxAreaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007BFF),
        title: Text('Filter Search'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city, color: Colors.blue),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Karachi',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Karachi'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Lahore',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Lahore'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Islamabad',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Islamabad'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Rawalpindi',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Rawalpindi'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Faisalabad',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Faisalabad'),
                      ],
                    ),
                  ),
                ],
                onChanged: (newValue)
                {
                  setState(()
                  {
                    _selectedCity = newValue;
                  }
                  );
                },
                iconEnabledColor: Colors.blue,
              ),
              TextFormField(
                controller: _projectTitleController,
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  prefixIcon: Icon(Icons.title, color: Colors.blue),
                ),
              ),
              TextFormField(
                controller: _projectTypeController,
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                ),
              ),
              TextFormField(
                controller: _minPriceController,
                decoration: InputDecoration(
                  labelText: 'Price Range (Min)',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _maxPriceController,
                decoration: InputDecoration(
                  labelText: 'Price Range (Max)',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Area Type',
                  prefixIcon: Icon(Icons.layers, color: Colors.blue),
                ),
                items: ['Square Feet', 'Square Yards', 'Square Meters', 'Marla', 'Kanal'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAreaType = newValue;
                  });
                },
              ),
              TextFormField(
                controller: _minAreaController,
                decoration: InputDecoration(
                  labelText: 'Area (Min)',
                  prefixIcon: Icon(Icons.square_foot, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _maxAreaController,
                decoration: InputDecoration(
                  labelText: 'Area (Max)',
                  prefixIcon: Icon(Icons.square_foot, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  OutlinedButton(
                    onPressed: () {
                      // Add reset functionality here
                      setState(() {
                        _selectedCity = null;
                        _selectedAreaType = null;
                        _projectTitleController.clear();
                        _projectTypeController.clear();
                        _minPriceController.clear();
                        _maxPriceController.clear();
                        _minAreaController.clear();
                        _maxAreaController.clear();
                      });
                    },
                    child: Text('Reset',
                      //style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)

                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Add search functionality here
                    },
                    child: Text('Search',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      //padding: EdgeInsets.symmetric(horizontal: 50),
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
