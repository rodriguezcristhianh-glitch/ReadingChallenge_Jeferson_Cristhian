
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Utils {
  static showSnackBar({
    required BuildContext context,
    required String title,
    Color? color,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(title), backgroundColor: color));
  }

  static showConfirm({
    required BuildContext context,
    void Function()? confirmButton,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Comfirmación'),
          content: Text('Desea realizar esta acción?'),
          actions: [
            TextButton(
              onPressed: confirmButton,
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                context.pop(false);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
