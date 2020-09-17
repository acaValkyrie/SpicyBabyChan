import 'dart:html';

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_speech/flutter_speech.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

const languages = const [const Language('Japanese', 'ja'),];

Language selectedLang = languages.first;

bool speechRecognitionAvailable = false;
bool isMach = false;

void printInfo(String str, var a){
  print("$str : $a");
}

List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages.map((l) => new CheckedPopupMenuItem<Language>(
  value: l,
  checked: selectedLang == l,
  child: new Text(l.name),
))
    .toList();

//void _selectLangHandler(Language lang) => setState(() => selectedLang = lang);
