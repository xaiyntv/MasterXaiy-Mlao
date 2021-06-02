import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlao/model/food_model.dart';
import 'package:mlao/model/groupfood_model.dart';
// import 'package:mlao/model/groupfood_model.dart';
import 'package:mlao/utility/my_constant.dart';
import 'package:mlao/utility/normal_dialog.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu(
      {Key key,
      this.foodModel,
      FoodModel foodModels,
      GroupFoodModel groupFoodModel})
      : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;

  @override
  void initState() {
    super.initState();
    foodModel = widget.foodModel;
    name = foodModel.nameFood;
    price = foodModel.price;
    detail = foodModel.detail;
    pathImage = foodModel.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('ແກ້ໄຂສິນຄ້າ ${foodModel.nameFood}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameFood(),
            groupImage(),
            priceFood(),
            detailFood(),
          ],
        ),
      ),
    );
  }
// Future<Null> uploadButton() async {
//     String urlUpload = '${MyConstant().domain}/mlao/saveFood.php';

//     Random random = Random();
//     int i = random.nextInt(1000000);
//     String nameFile = 'food$i.jpg';

//     try {
//       Map<String, dynamic> map = Map();
//       map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
//       FormData formData = FormData.fromMap(map);

//       await Dio().post(urlUpload, data: formData).then((value) async {
//         String urlPathImage = '/mlao/Food/$nameFile';
//         print('urlPathImage = ${MyConstant().domain}$urlPathImage');

//         SharedPreferences preferences = await SharedPreferences.getInstance();
//         String idShop = preferences.getString('id');

//         String urlInsertData =
//             '${MyConstant().domain}/mlao/addFood.php?isAdd=true&idShop=$idShop&NameFood=$nameFood&PathImage=$urlPathImage&Price=$price&Detail=$detail';
//         await Dio().get(urlInsertData).then((value) => Navigator.pop(context));
//       });
//     } catch (e) {}
//   }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (name.isEmpty || price.isEmpty || detail.isEmpty) {
          normalDialog(context, 'ກະລຸກາໃສ່ຂ້ມູນໃຫ້ຄົບ');
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ທ່ານຕ້ອງການຈະປ່ນແປງຂໍ້ມູນສິນຄ້ານີ້ແທ້ບໍ ?'),
        children: <Widget>[
          Row(
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('ຍອມຮັບ'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ປະຕິເສດ'),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {
    String id = foodModel.id;
    String url =
        '${MyConstant().domain}/mlao/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&PathImage=$pathImage&Price=$price&Detail=$detail';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ກະລຸນາລອງໄໝ່ ຂໍ້ມູນ ? ຜິດພາດ');
      }
    });
  }

  Widget groupImage() => Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: 250.0,
            height: 250,
            child: file == null
                ? Image.network(
                    '${MyConstant().domain}${foodModel.pathImage}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              initialValue: name,
              decoration: InputDecoration(
                labelText: 'ຊື່ສິນຄ້າ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              keyboardType: TextInputType.number,
              initialValue: price,
              decoration: InputDecoration(
                labelText: 'ລາຄາ ສິນຄ້າ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => detail = value.trim(),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              initialValue: detail,
              decoration: InputDecoration(
                labelText: 'ລາຍລະອຽດ ສິນຄ້າ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
