import 'package:flutter/material.dart';
import 'package:manajemen_pariwisata/bloc/logout_bloc.dart';
import 'package:manajemen_pariwisata/bloc/hargatiket_bloc.dart';
import 'package:manajemen_pariwisata/model/hargatiket.dart';
import 'package:manajemen_pariwisata/ui/login_page.dart';
import 'package:manajemen_pariwisata/ui/tiket_detail.dart';
import 'package:manajemen_pariwisata/ui/tiket_form.dart';

class TiketPage extends StatefulWidget {
  const TiketPage({Key? key}) : super(key: key);

  @override
  _TiketPageState createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  late Future<List<Tiket>> _tiketFuture;

  @override
  void initState() {
    super.initState();
    _fetchTiket(); // Fetch tickets when the widget is initialized
  }

  void _fetchTiket() {
    setState(() {
      _tiketFuture = TiketBloc.getTiket(); // Fetch tickets and update future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Tiket',
          style: TextStyle(fontFamily: 'Arial', color: Colors.white),
        ),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                // Navigate to the TiketForm and wait for the result
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TiketForm()),
                );
                // After returning from TiketForm, fetch the tickets again
                _fetchTiket();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Arial', color: Colors.red),
              ),
              trailing: const Icon(Icons.logout, color: Colors.red),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Tiket>>(
        future: _tiketFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontFamily: 'Arial', color: Colors.red),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No tickets available',
                style: TextStyle(fontFamily: 'Arial', color: Colors.red),
              ),
            );
          }
          return ListTiket(
            list: snapshot.data!,
          );
        },
      ),
    );
  }
}

class ListTiket extends StatelessWidget {
  final List<Tiket> list;

  const ListTiket({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ItemTiket(
          tiket: list[index],
        );
      },
    );
  }
}

class ItemTiket extends StatelessWidget {
  final Tiket tiket;

  const ItemTiket({Key? key, required this.tiket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TiketDetail(
              tiket: tiket,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.red[50], // Background color for the card
        child: ListTile(
          title: Text(
            tiket.event ?? 'Unknown Event',
            style: const TextStyle(fontFamily: 'Arial', color: Colors.red),
          ),
          subtitle: Text(
            '${tiket.price ?? 'Unknown Price'} - ${tiket.seat ?? 'Unknown Seat'}',
            style: const TextStyle(fontFamily: 'Arial', color: Colors.red),
          ),
        ),
      ),
    );
  }
}
