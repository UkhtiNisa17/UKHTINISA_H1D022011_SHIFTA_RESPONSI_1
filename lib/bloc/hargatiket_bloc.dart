import 'dart:convert';
import 'package:manajemen_pariwisata/helpers/api.dart';
import 'package:manajemen_pariwisata/helpers/api_url.dart';
import 'package:manajemen_pariwisata/model/hargatiket.dart';

class TiketBloc {
  static Future<List<Tiket>> getTiket() async {
    String apiUrl = ApiUrl.listTiket;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listTiket = (jsonObj as Map<String, dynamic>)['data'];
    List<Tiket> tiket = [];
    for (int i = 0; i < listTiket.length; i++) {
      tiket.add(Tiket.fromJson(listTiket[i]));
    }
    return tiket;
  }

  static Future<Tiket?> addTiket({required Tiket tiket}) async {
    String apiUrl = ApiUrl.createTiket;
    var body = {
      "event": tiket.event,
      "price": tiket.price,
      "seat": tiket.seat,
    };

    try {
      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);

      if (jsonObj['status'] == true) {
        // Mengembalikan tiket yang baru ditambahkan
        return Tiket.fromJson(jsonObj['data']);
      }
    } catch (e) {
      print("Error adding tiket: $e");
    }
    return null; // Mengembalikan null jika gagal
  }

  static Future<bool> updateTiket({required Tiket tiket}) async {
    String apiUrl = ApiUrl.updateTiket(tiket.id!);
    var body = {
      "event": tiket.event,
      "price": tiket.price,
      "seat": tiket.seat,
    };

    try {
      var response = await Api().put(apiUrl, jsonEncode(body));
      var jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } catch (e) {
      print("Error updating tiket: $e");
      return false;
    }
  }

  static Future<bool> deleteTiket({int? id}) async {
    String apiUrl = ApiUrl.deleteTiket(id!);
    var response = await Api().delete(apiUrl);

    if (response != null && response.body.isNotEmpty) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      return false;
    }
  }
}
