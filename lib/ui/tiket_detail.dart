import 'package:flutter/material.dart';
import 'package:manajemen_pariwisata/bloc/hargatiket_bloc.dart';
import 'package:manajemen_pariwisata/model/hargatiket.dart';
import 'package:manajemen_pariwisata/ui/tiket_form.dart';
import 'package:manajemen_pariwisata/ui/tiket_page.dart';
import 'package:manajemen_pariwisata/widget/warning_dialog.dart';
import 'package:manajemen_pariwisata/widget/success_dialog.dart';

class TiketDetail extends StatefulWidget {
  final Tiket? tiket;

  const TiketDetail({Key? key, this.tiket}) : super(key: key);

  @override
  _TiketDetailState createState() => _TiketDetailState();
}

class _TiketDetailState extends State<TiketDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tiket'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailText("Event", widget.tiket?.event),
              const SizedBox(height: 10),
              _buildDetailText("Price", widget.tiket?.price.toString()),
              const SizedBox(height: 10),
              _buildDetailText("Seat", widget.tiket?.seat),
              const SizedBox(height: 30),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan detail dengan gaya yang konsisten
  Widget _buildDetailText(String label, String? value) {
    return Text(
      "$label: ${value ?? '-'}",
      style: const TextStyle(
        fontSize: 18.0,
        fontFamily: 'Arial',
        color: Colors.red,
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TiketForm(
                  tiket: widget.tiket!,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: confirmHapus,
        ),
      ],
    );
  }

  void confirmHapus() {
    if (widget.tiket?.id == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "ID Tiket tidak ditemukan, tidak bisa menghapus.",
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          "Yakin ingin menghapus data ini?",
          style: TextStyle(fontFamily: 'Arial'),
        ),
        actions: [
          OutlinedButton(
            child: const Text("Ya"),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog konfirmasi
              bool success = await TiketBloc.deleteTiket(
                id: widget.tiket!.id!,
              );
              if (success) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => SuccessDialog(
                    description: "Tiket berhasil dihapus",
                    okClick: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const TiketPage(),
                        ),
                      );
                    },
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              }
            },
          ),
          OutlinedButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
