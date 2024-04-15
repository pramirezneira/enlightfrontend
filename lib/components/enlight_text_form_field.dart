import 'package:flutter/material.dart';

class EnlightTextFormField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final bool email;
  final bool password;
  final bool date;

  const EnlightTextFormField({
    super.key,
    required this.text,
    required this.controller,
    this.email = false,
    this.password = false,
    this.date = false,
  });

  @override
  State<EnlightTextFormField> createState() => _EnlightTextFormFieldState();
}

class _EnlightTextFormFieldState extends State<EnlightTextFormField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: widget.controller,
        obscureText: obscure,
        readOnly: widget.date,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "${widget.text} cannot be empty.";
          }
          if (widget.email) {
            if ("@".allMatches(widget.controller.text).length != 1) {
              return "Invalid email.";
            }
            if (!widget.controller.text.split("@")[1].contains(".")) {
              return "Invalid email.";
            }
          }
          if (!widget.date) {
            return null;
          }
          if (!RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[01])$')
              .hasMatch(value)) {
            return "Invalid date.";
          }
          DateTime now = DateTime.now();
          DateTime sixteenYearsAgo =
              DateTime(now.year - 16, now.month, now.day);
          if (DateTime.parse(value).isAfter(sixteenYearsAgo)) {
            return "You must be at least 16 years old to use Enlight.";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: widget.text,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          suffixIcon: widget.password
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
        ),
        onTap: widget.date
            ? () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? dateTime = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                dateTime != null
                    ? widget.controller.text = dateTime.toString().split(" ")[0]
                    : null;
              }
            : null,
      ),
    );
  }
}
