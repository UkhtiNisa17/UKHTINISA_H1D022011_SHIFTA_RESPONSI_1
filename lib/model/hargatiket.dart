class Tiket {
  int? id; // ID akan dihasilkan oleh database
  String? event;
  int? price; // Harga sebagai integer
  String? seat;

  Tiket({this.id, this.event, this.price, this.seat});

  // Factory constructor untuk membuat instance Tiket dari JSON
  factory Tiket.fromJson(Map<String, dynamic> obj) {
    return Tiket(
      id: obj['id'] != null
          ? int.tryParse(obj['id'].toString()) // Mengubah ID menjadi integer
          : null,
      event: obj['event'],
      price: obj['price'] != null
          ? int.tryParse(
              obj['price'].toString()) // Memastikan price sebagai integer
          : null,
      seat: obj['seat'],
    );
  }

  // Method untuk mengubah objek Tiket menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ID bisa disertakan jika sudah ada
      'event': event,
      'price': price, // Pastikan price sebagai integer
      'seat': seat,
    };
  }
}
