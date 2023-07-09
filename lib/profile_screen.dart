

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'map_view.dart';

class Profile extends StatefulWidget{
  @override
  ProfileScreen createState() => ProfileScreen();
}



class ProfileScreen extends State<Profile> {
    @override
      late BuildContext context;
    ImagePicker picker = ImagePicker();
    File? image;
    final TextEditingController _dateOfBirthController =
      TextEditingController(text: "01-01-2000");
    final TextEditingController _locationController =
      TextEditingController(text: "Set Current Location");

    late double _latitude = 0;
    late double _longitude = 0;
    late String address = "";

    @override
    Widget build(BuildContext context) {
    this.context = context;
    Widget profilePhotoCell = _buildProfilePhotoCell();
    Widget birthDateCell = _buildBirthDateCell();
    Widget emptyBox = const SizedBox(height: 20);
    Widget dateOfBirthHeading = _buildHeading("Date of Birth");
    Widget locationHeading = _buildHeading("Set Current Location");
    Widget locationTextField = _buildLocationTextField();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profilePhotoCell,
            emptyBox,
            dateOfBirthHeading,
            birthDateCell,
            emptyBox,
            locationHeading,
            locationTextField,
            emptyBox,
          ],
        ),
      ),
    );
  }



  Widget _buildProfilePhotoCell() {
    return (
      Column(
        children: <Widget>[
          _buildPhotoWidget(),
          _emptyBox,
          _buildChangePhotoButton()
        ],
      )
    );
  }

  final Widget _emptyBox = const SizedBox(height: 20);

  Widget _buildPhotoWidget() {
    return InkWell(
      onTap: () {
        openChangePhotoActionsheet();
      },
      child: (
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image != null ? 
            ClipOval(
              child: Image.file(
                image!,
                width: 160,
                height: 160,
                fit: BoxFit.cover
              ),
            ) :
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), shape: BoxShape.circle, color: Colors.blue),
              width: 160,
              height: 160,
            )
          ],
        )
      ),
    );
  }

  Widget _buildChangePhotoButton() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Text('Change Photo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),),
            onTap: () {
              openChangePhotoActionsheet();
            },
          )
      ],)
    );
  }

  openChangePhotoActionsheet() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
        actions: [
         CupertinoActionSheetAction(onPressed: () {
          Navigator.pop(context);
          selectImageSource(ImageSource.camera);
          },
          child: const Text('Camera')),
          CupertinoActionSheetAction(onPressed: () {
            Navigator.pop(context);
            selectImageSource(ImageSource.gallery);
          },
          child: const Text('Gallary'))
        ]
      )
    );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Gallary'),
              onTap: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
              },
            ),
          ]),
        );
    }
  }

  selectImageSource(ImageSource source) async {
    try {
      final image = await picker.pickImage(source: source); 
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
  }


  Widget _buildBirthDateCell() {
    return (
      Column(
        children: <Widget>[
          _buildBirthDateTextField(),
        ],
      )
    );
  }

  Widget _buildBirthDateTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          showCursor: true,
          readOnly: true,
          onTap: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now())
                .then((date) {
                  //code to handle date
                  _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now()).toString();
            });
          },
          controller: _dateOfBirthController,
          decoration: _getTextFieldWithCalendarIconDecoration(),
        )
      ],
    );
  }

  Widget _buildLocationTextField() {
    _locationController.text = address.isEmpty ? "Click to set location" : "$_longitude:$_latitude";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          showCursor: true,
          readOnly: true,
          onTap: () {
            _openMap();
          },
          controller: _locationController,
          decoration: _getTextFieldWithLocationIconDecoration(),
        )
      ],
    );
  }

  InputDecoration _getTextFieldWithCalendarIconDecoration() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      suffixIcon: Icon(
        Icons.date_range,
        color: Theme.of(context).primaryColor,
      ),
      hintText: '2017-04-10',
    );
  }

  InputDecoration _getTextFieldWithLocationIconDecoration() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      suffixIcon: Icon(
        Icons.location_on,
        color: Theme.of(context).primaryColor,
      ),
      hintText: '2017-04-10',
    );
  }

  Widget _buildHeading(String headingTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            headingTitle, style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _openMap() async {
    // Navigate to the map screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    // Get the latitude and longitude from the result
    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        address = address.isEmpty ? "Click to set location" : "$_longitude:$_latitude";
        _locationController.text = address.isEmpty ? "Click to set location" : "$_longitude:$_latitude";
      });
    }
  }
}