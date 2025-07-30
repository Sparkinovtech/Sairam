import 'package:flutter/material.dart';
Future<bool> showProgress(BuildContext context) async {
    return showDialog(context: context, builder: (context){
        return Dialog(

        );
    }).then( (value) => value ?? false);
}
