import 'package:flutter/material.dart';

class Consts {
  Consts._(); // Konstruktor privat untuk mencegah instansiasi

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class WarningDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const WarningDialog({
    Key? key,
    this.description,
    this.okClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(
          context), // Menggunakan metode privat untuk dialog content
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Consts.padding),
      margin: const EdgeInsets.only(top: Consts.avatarRadius),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "GAGAL",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            description ??
                'Terjadi kesalahan', // Menghindari null pada description
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                if (okClick != null) {
                  okClick!(); // Menjalankan callback jika disediakan
                }
              },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}