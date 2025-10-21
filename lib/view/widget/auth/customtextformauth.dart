import 'package:softel/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextFormAuth extends StatefulWidget {
  final String labeltext;
  final Widget iconData;
  final Widget? iconData2;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final GlobalKey<FormState> formstate;
  final bool isNumber;
  final bool isactive;
  final bool? obscureText;
  final int? max;
  final TextInputAction? textinputaction;
  final TextInputType? textinputtype;

  const CustomTextFormAuth({
    super.key,
    this.obscureText,
    required this.labeltext,
    required this.iconData,
    this.iconData2,
    this.max,
    this.isactive = true,
    required this.formstate,
    required this.mycontroller,
    required this.valid,
    required this.isNumber,
    this.textinputaction = TextInputAction.next,
    this.textinputtype = TextInputType.text,
  });

  @override
  State<CustomTextFormAuth> createState() => _CustomTextFormAuthState();
}

class _CustomTextFormAuthState extends State<CustomTextFormAuth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      height: Get.height * 0.1,
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        enabled: widget.isactive,
        maxLength: widget.max,
        controller: widget.mycontroller,
        validator: widget.valid,
        // onChanged: (value) {
        //   setState(() {
        //     widget.formstate.currentState!.validate();
        //   });
        // },
        autovalidateMode: AutovalidateMode.onUserInteraction,

        onSaved: (newValue) {
          setState(() {
            widget.formstate.currentState!.validate();
          });
        },
        keyboardType: widget.textinputtype,
        obscureText: widget.obscureText ?? false,
        style: const TextStyle(fontFamily: "Cairo", fontSize: 18, fontWeight: FontWeight.w600),
        cursorColor: AppColor.primaryColor,
        textInputAction: widget.textinputaction,
        inputFormatters: widget.isNumber
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
            : [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9@.]'), ''));
                }),
              ],
        decoration: InputDecoration(
          labelStyle: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600),
          labelText: widget.labeltext,
          prefixIcon: widget.iconData2,
          suffixIcon: widget.iconData,
          filled: true,
          fillColor: AppColor.background,

          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
