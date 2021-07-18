import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      controller: phoneNumber,
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFb0cbf8).withOpacity(0.4),
        hintText: "Phone Number",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
        prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "+91 ",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  color: Colors.grey,
                  width: 1.5,
                  height: 18,
                ),
              ],
            )),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value!.length != 10) {
          return "Invalid phone number";
        }
        return null;
      },
    ));
  }
}
