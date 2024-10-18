import 'package:flutter/material.dart';
import 'package:manajemen_pariwisata/bloc/hargatiket_bloc.dart';
import 'package:manajemen_pariwisata/model/hargatiket.dart';
import 'package:manajemen_pariwisata/ui/tiket_page.dart';
import 'package:manajemen_pariwisata/widget/warning_dialog.dart';
import 'package:manajemen_pariwisata/widget/success_dialog.dart';

class TiketForm extends StatefulWidget {
  final Tiket? tiket;
  const TiketForm({Key? key, this.tiket}) : super(key: key);

  @override
  _TiketFormState createState() => _TiketFormState();
}

class _TiketFormState extends State<TiketForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String judul;
  late String tombolSubmit;
  final _eventController = TextEditingController();
  final _priceController = TextEditingController();
  final _seatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.tiket != null) {
      judul = "UBAH TIKET";
      tombolSubmit = "UBAH";
      _eventController.text = widget.tiket!.event ?? '';
      _priceController.text = widget.tiket!.price?.toString() ?? '';
      _seatController.text = widget.tiket!.seat ?? '';
    } else {
      judul = "TAMBAH TIKET";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  void dispose() {
    _eventController.dispose();
    _priceController.dispose();
    _seatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(fontFamily: 'Arial')),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _eventController,
                label: "EVENT",
                validator: (value) =>
                    value == null || value.isEmpty ? "Event harus diisi" : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _priceController,
                label: "Price Tiket",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Price harus diisi";
                  if (int.tryParse(value) == null)
                    return "Price harus berupa angka";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _seatController,
                label: "Seat Tiket",
                validator: (value) =>
                    value == null || value.isEmpty ? "Seat harus diisi" : null,
              ),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.red, fontFamily: 'Arial'),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        textStyle: const TextStyle(fontFamily: 'Arial'),
        side: const BorderSide(color: Colors.red),
      ),
      child: Text(tombolSubmit, style: const TextStyle(color: Colors.red)),
      onPressed: _isLoading ? null : _handleSubmit,
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.tiket != null) {
          await _updateTiket();
        } else {
          await _addTiket();
        }
        _showSuccessDialog();
      } catch (error) {
        _showErrorDialog();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addTiket() async {
    Tiket newTiket = Tiket(
      id: null, // ID diatur oleh database
      event: _eventController.text,
      price: int.tryParse(_priceController.text),
      seat: _seatController.text,
    );

    await TiketBloc.addTiket(tiket: newTiket);
  }

  Future<void> _updateTiket() async {
    Tiket updatedTiket = Tiket(
      id: widget.tiket!.id,
      event: _eventController.text,
      price: int.tryParse(_priceController.text),
      seat: _seatController.text,
    );

    await TiketBloc.updateTiket(tiket: updatedTiket);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        description: widget.tiket != null
            ? "Tiket berhasil diubah"
            : "Tiket berhasil ditambah",
        okClick: () {
          // Kembali ke halaman TiketPage setelah sukses
          Navigator.of(context).pop(); // Tutup dialog
          Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
        },
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => const WarningDialog(
        description: "Operasi gagal, silahkan coba lagi",
      ),
    );
  }
}
