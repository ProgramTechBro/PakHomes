import 'package:flutter/cupertino.dart';

class AddProperty with ChangeNotifier{
  bool isProductSaving=false;
  List<String> imageUrL=[];
  String propertyId='';
  updateProductImagesURL({required String imagesURLs}) async {
    imageUrL.add(imagesURLs);
    notifyListeners();
  }
  updatePropertyId(String id){
    propertyId=id;
    notifyListeners();
  }
  emptyImageUrls(){
    imageUrL=[];
  }
  emptyPropertyId(){
    propertyId='';
  }

}