import 'package:flutter/material.dart';

class Consts {
  Consts._(); // Konstruktor privat agar tidak bisa diinisialisasi dari luar

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class SuccessDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const SuccessDialog({
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
      child: _dialogContent(context), // Memanggil konten dialog
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
            "SUKSES",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            description ??
                'Operasi berhasil', // Menghindari null dengan teks default
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomRight,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                if (okClick != null) {
                  okClick!(); // Menjalankan aksi OK jika ada
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
