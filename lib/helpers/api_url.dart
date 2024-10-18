class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';
  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listTiket = baseUrl + 'api/pariwisata/harga_tiket';
  static const String createTiket = baseUrl + 'api/pariwisata/harga_tiket';
  static String updateTiket(int id) {
    return baseUrl + 'api/pariwisata/harga_tiket/' + id.toString() + '/update';
  }

  static String showTiket(int id) {
    return baseUrl + 'api/pariwisata/harga_tiket/' + id.toString();
  }

  static String deleteTiket(int id) {
    return baseUrl + 'api/pariwisata/harga_tiket/' + id.toString() + '/delete';
  }
}
