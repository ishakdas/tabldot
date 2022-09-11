import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/service/web_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({required this.id, Key? key}) : super(key: key);
  final int id;
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ad = TextEditingController();
  final soyad = TextEditingController();
  final telefon = TextEditingController();
  final adres = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sipariş oluştur')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _textFormField(hintText: "Ad", controller: ad),
            _textFormField(hintText: "Soyad", controller: soyad),
            _textFormField(hintText: "Telefon", controller: telefon),
            _textFormField(hintText: "Adres", controller: adres),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createOrder();
                    }
                  },
                  child: const Text('Siparişi Oluştur'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFormField({required String hintText, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
        validator: validatorIsEmpty,
      ),
    );
  }

  String? validatorIsEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Boş geçilemez';
    }
    return null;
  }

  _createOrder() async {
    try {
      final newItems = await WebService().addOrder(ad: ad, soyad: soyad, telefon: telefon, adres: adres, urun_id: widget.id);
      if (newItems != null) {
        await Fluttertoast.showToast(
            msg: "Sipariş Oluşturuldu. Ana ekrandan Siparişinizin durumunu kontrol edebilirsiniz. Sipariş no:  $newItems",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
