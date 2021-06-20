import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

//void main() => runApp(MyApp());

final Color yellow = Color(0xfffbc31b);
final Color orange = Color(0xfffb6900);

class Fruitdata {
  String id;
  String category;

  Fruitdata({
    this.id,
    this.category,
  });

  factory Fruitdata.fromJson(Map<String, dynamic> json) {
    return Fruitdata(
      id: json['id'],
      category: json['category'],
    );
  }
}

class Fruitdata2 {
//  String id;
  String subcategory;

  Fruitdata2({
//    this.id,
    this.subcategory,
  });

  factory Fruitdata2.fromJson(Map<String, dynamic> json) {
    return Fruitdata2(
//      id: json['id'],
      subcategory: json['subcategory'],
    );
  }
}

class product_master extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState extends State<product_master> {
  File _imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final sizeController = TextEditingController();
  final descriptionController = TextEditingController();
  String categoryvalue;
  String subcategoryvalue;
  Future subcategoryfuture;

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<List<Fruitdata>> fetchcategory() async {
    var response = await http
        .get('https://www.mireport.in/sms_mobile/satyam_flutter_category_spinner.php');

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Fruitdata> listOfFruits = items.map<Fruitdata>((json) {
        return Fruitdata.fromJson(json);
      }).toList();

      return listOfFruits;
    } else {
      throw Exception('Failed to load data.');
    }
  }

  Future<List<Fruitdata2>> fetchsubcategory(String category) async {
    var data = {
      "category": category.toString(),

    };
    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_subcategory_spinner.php';
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

//    var response = await http
//        .get('https://www.mireport.in/sms_mobile/flutter_subcategory_spinner.php');

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Fruitdata2> listOfFruits = items.map<Fruitdata2>((json) {
        return Fruitdata2.fromJson(json);
      }).toList();

      return listOfFruits;
    } else {
      throw Exception('Failed to load data.');
    }
  }

  Future addProduct(File imageFile, BuildContext context) async {
// ignore: deprecated_member_use

    var stream = new http.ByteStream(
        DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://www.mireport.in/sms_mobile/satyam_flutter_add_product.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile(
        "image", stream, length, filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['productname'] = nameController.text;
    request.fields['category'] = categoryvalue.toString();
    request.fields['subcategory'] = subcategoryvalue.toString();
    request.fields['price'] = priceController.text;
    request.fields['size'] = sizeController.text;
    request.fields['description'] = descriptionController.text;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("Image Uploaded"),
          action: SnackBarAction(
              label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else {
      print("Upload Failed");
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("Upload Failed"),
          action: SnackBarAction(
              label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
  }

//  Future uploadImageToFirebase(BuildContext context) async {
//    String fileName = basename(_imageFile.path);
//    StorageReference firebaseStorageRef =
//    FirebaseStorage.instance.ref().child('uploads/$fileName');
//    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//    taskSnapshot.ref.getDownloadURL().then(
//          (value) => print("Done: $value"),
//    );
//  }

  @override
  void initState() {
    super.initState();

    fetchcategory();
//    fetchsubcategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Product Master",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
//                        width : double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 30.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile)
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImage,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: nameController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 10.0),
                FutureBuilder<List<Fruitdata>>(
                    future: fetchcategory(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(3.0)),
                            child: DropdownButton<String>(
                              value: categoryvalue,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down, size: 22),
                              underline: SizedBox(),
                              hint: Text('Select Category'),
                              items: snapshot?.data.map((data) {
                                return new DropdownMenuItem<String>(
                                  value: data.category,
                                  child: new Text(
                                    data.category,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList() ??
                                  [],
                              onChanged: (value) {
                                //Do something with this value
                                setState(() {
                                  categoryvalue = value;
                                  subcategoryfuture = fetchsubcategory(value.toString());
                                });
                              },
                            ),
                          );
                      }
                    }),
                SizedBox(height: 10.0),
                provideSecondDropdown(),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: priceController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        labelText: "Price", border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: sizeController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        labelText: "Size", border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: descriptionController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        labelText: "Description", border: OutlineInputBorder()),
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget provideSecondDropdown() {
    if (subcategoryfuture == null) {
      // the user didn't select anything from the first dropdown so you probably want to show a disabled dropdown
      return DropdownButton<String>(
          items: [],
          onChanged: null);
          }
          // return the FutureBuilder based on what the user selected
          return FutureBuilder<List<Fruitdata2>>(
              future: subcategoryfuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3.0)),
                      child: DropdownButton<String>(
                        value: subcategoryvalue,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down, size: 22),
                        underline: SizedBox(),
                        hint: Text('Select Subcategory'),
                        items: snapshot?.data.map((data) {
                          return new DropdownMenuItem<String>(
                            value: data.subcategory,
                            child: new Text(
                              data.subcategory,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList() ??
                            [],
                        onChanged: (value) {
                          //Do something with this value
                          setState(() {
                            subcategoryvalue = value;
//                            subcategoryfuture = fetchsubcategory(value.toString());
                          });
                        },
                      ),
                    );
                }
              });
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: () => addProduct(_imageFile,context),
              child: Text(
                "Add Product",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
