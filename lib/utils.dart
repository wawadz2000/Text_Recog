import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Command {
  static final all = [email, browser1, app];

  static const email = 'write email';
  static const browser1 = 'open link';
  static const app = 'go to app';
  static const call = 'call number';
  static final packages = {
    'facebook':"com.facebook.katana",
    'instagram': "com.instagram.android",
    'youtube':"com.google.android.youtube",
    'setting':"com.android.settings",
    'maps': "com.google.android.apps.maps",
    'snapchat':"com.snapchat.android",
    'camera': "com.sec.android.app.camera",
    'events':"com.samsung.android.calendar",
    'notes': "com.samsung.android.app.memo",
    'calculator': "com.sec.android.app.popupcalculator",
  };
}

class Utils {
  static void scanText(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains(Command.email)) {
      final body = _getTextAfterCommand(text: text, command: Command.email);

      openEmail(body: body);
    } else if (text.contains(Command.browser1)) {
      final url = _getTextAfterCommand(text: text, command: Command.browser1);

      openLink(url: url);
    } else if (text.contains(Command.app)) {
      final url = _getTextAfterCommand(text: text, command: Command.app);

      openLink(url: url);
      
    } else if (text.contains(Command.call)) {
      final String url = _getTextAfterCommand(text: text, command: Command.call);

      PhoneCall(body: url);
    }
  }

  static String _getTextAfterCommand({
    @required String text,
    @required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return null;
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  static Future openLink({
    @required String url,
  }) async {
    if (url.trim().isEmpty) {
      await _launchUrl('https://google.com');
    }else{ 
    if (Command.packages.containsKey(url)) {
      await OpenExtApp(Command.packages['$url']);
    }
    else {
      await _launchUrl('https://$url.com');
    } 
     }
  }

  static Future openEmail({
    @required String body,
  }) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }
  static Future PhoneCall({
    @required String body,
  }) async {
    final url = 'tel:$body';
    await launch(url);
  }
  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static Future OpenExtApp(String package) async {
   await LaunchApp.openApp(
      androidPackageName: package,
      // openStore: false
    );
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/speechText.txt');
  }

  static Future<File> writeContent(String content) async {
    final file = await _localFile;

  // Write the file
    return file.writeAsString('$content');    
  }

  static void readFile() async {
    
    File file = File(_localFile.toString()); // 1
    String fileContent = await file.readAsString(); // 2
    print('File Content: $fileContent');
    }

}
