import 'package:flutter/material.dart';

import '../core/model/order_model.dart';
import '../core/service/web_service.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final sip_no = TextEditingController();
  final telefon = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<OrderModel?>? newItems;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  _textFormField(hintText: "Sipariş No", controller: sip_no),
                  _textFormField(hintText: "Telefon Numarası", controller: telefon),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _OrderbyID();
                          }
                        },
                        child: const Text('Sorgula'),
                      ),
                    ),
                  ),
                ],
              )),
          const Center(
            child: Text(
              "Sipraiş bilgileri",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          if (newItems != null && newItems!.isNotEmpty)
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  customText(" ID:" + newItems![0]!.id.toString()),
                  customText(" Adı: " + newItems![0]!.attributes!.ad.toString()),
                  customText(" Soyadı: " + newItems![0]!.attributes!.soyad.toString()),
                  customText(" Telefon: " + newItems![0]!.attributes!.telefon.toString()),
                  customText(" Güncelleme Tarihi: " + newItems![0]!.attributes!.guncellemeTarihi.toString()),
                  customText(" Sipariş Durumu: " + newItems![0]!.attributes!.siparisDurumu.toString()),
                  customText(" Adres: " + newItems![0]!.attributes!.adres.toString()),
                ],
              ),
            )
        ],
      ),
    );
  }

  Padding customText(String text) => Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            Container(
              height: 1,
              color: Colors.grey[600],
            )
          ],
        ),
      );

  _OrderbyID() async {
    try {
      newItems = await WebService().orderfindByIdAndPhone(sip_no: sip_no.text, telefon: telefon.text);
      if (newItems != null) {
        setState(() {});
        print(newItems);
      } else {}
    } catch (e) {
      print(e);
    }
  }
}

Widget _textFormField({required String hintText, required TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: TextFormField(
      cursorColor: Colors.red,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true, // dont forget this line
      ),
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
