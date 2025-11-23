import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

//url
const baseURL = 'http://192.168.1.2:5000';

//color list

const Color lightBlue = Color(0xffdbf0f1);
const Color darkBlue = Color(0xff39888e);
const Color yellow = Color(0xffffe9a7);
const Color pink = Color(0xfff1e7f5);
const primaryColor = Color(0xFF5C6BC0);
const secondColor = Color(0xFF7986CB);
const backgroundColor = Color(0xFFE8EAF6);
const textColor = Color(0xFF35364F);
const redColor = Color(0xFFE85050);
const sdColor = Colors.black12;

//size list
const defaultPadding = 16.0;

//border style

OutlineInputBorder textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: primaryColor.withOpacity(0.1),
  ),
);

//email and password validation

const emailError = 'Enter a valid email address';
const requiredField = 'This field is required';

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character')
  ],
);
String? validatePhoneNumber(String? value) {
  final digitsOnly = value?.replaceAll(RegExp(r'[^0-9]'), '');

  if (digitsOnly!.isEmpty || digitsOnly.length < 8) {
    return 'Phone number is incorrect , enter a correct one';
  }
  return null;
}
