import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
  String? _selectedCity;
  String? _selectedProperty;
  String? _selectedProjectType;
  String? _selectedAreaType;

  String? get selectedCity => _selectedCity;
  String? get selectedProperty => _selectedProperty;
  String? get selectedProjectType => _selectedProjectType;
  String? get selectedAreaType => _selectedAreaType;

  void setCity(String? value) {
    _selectedCity = value;
    notifyListeners();
  }

  void setPropertyType(String? value) {
    _selectedProperty = value;
    notifyListeners();
  }

  void setProjectType(String? value) {
    _selectedProjectType = value;
    notifyListeners();
  }
  void setAreaType(String? value) {
    _selectedAreaType = value;
    notifyListeners();
  }
}
