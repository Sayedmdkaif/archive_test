import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';

import 'CommonWidgets.dart';
class CustomTextField extends StatefulWidget {
  String? hint;
  TextEditingController? controller;
  Function(String)? onTextChanged;
  Function? onTap;
  Function? onSufficeTap;
  Function(String)? validator;
  bool isObscure;
  bool collapsed;
  bool filled;
  bool boarder;
  bool isPassword;
  int? maxLength;
  int? maxLines;
  bool isNumber;
  bool enabled;
  TextInputType? keyboardType;
  bool? focus;
  bool? autoFocus;
  FocusNode? focusNode;
  Color? fillColor;
  Color? iconColor;
  Color? cursorColor;
  double? radius;
  String activeSuffix;
  String activePrefix;
  String inActivePrefix;
  String inActiveSuffix;
  TextAlign? textAlign;
  TextStyle? textStyle;
  TextStyle? hintStyle;
  TextStyle? labelStyle;

  CustomTextField({
    this.labelStyle,
    this.keyboardType,
    this.radius,
    this.hint,
    this.onTap,
    this.onSufficeTap,
    this.iconColor,
    this.cursorColor,
    this.autoFocus = false,
    this.isPassword = false,
    this.hintStyle,
    this.controller,
    this.fillColor,
    this.onTextChanged,
    this.isObscure = false,
    this.collapsed = false,
    this.filled = false,
    this.boarder = true,
    this.maxLength,
    this.focusNode,
    this.focus,
    this.validator,
    this.isNumber = false,
    this.enabled = true,
    this.activePrefix = '',
    this.activeSuffix = '',
    this.inActivePrefix = '',
    this.inActiveSuffix = '',
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.maxLines,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String text='';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: true,
      onEditingComplete: () => getNode(context).nextFocus(),
cursorColor: widget.cursorColor,
      autofocus: widget.autoFocus!,
      focusNode: widget.focusNode,
      onChanged: (String value) {

        if(widget.onTextChanged!=null)
          widget.onTextChanged!(value);

        setState(() {
          text=value;
        });

      },
      validator: (ab) => widget.validator!(ab!),
      textAlign: widget.textAlign!,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.isNumber ? [FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),] : null,
      controller: widget.controller,
      obscureText: widget.isObscure,
      decoration: !widget.collapsed
          ? new InputDecoration(

        fillColor: widget.fillColor,
        filled: true,
        focusColor: Colors.black,
        hoverColor: Colors.black,
        labelText: widget.hintStyle==null?null:widget.hint,
          labelStyle: widget.labelStyle,

          enabledBorder:!widget.boarder?  UnderlineInputBorder(
            borderSide: BorderSide(color: darkBlue2, width: 2.0)):null,


        disabledBorder: !widget.boarder?UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)):null,


        border: widget.boarder?OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ):UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),




        suffixIcon: widget.activeSuffix.isEmpty
            ? null
            : InkWell(
          onTap: () {
            if (widget.isPassword)
              setState(() {
                widget.isObscure = !widget.isObscure;
              });
            else
            {
              widget.onSufficeTap!();
              print('kaif');

            }
          },
          child: Container(
            width: 22,
            margin: 16.marginLeft(),
            child: Row(
              children: <Widget>[

                text.isNotEmpty?  GestureDetector(

                  onTap: () {

                    setState(() {
                      text='';
                      widget.onTextChanged!('');
                    });

                  },
                  child: SvgPicture.asset(widget.activeSuffix,
                    width: 20,height: 20, ),
                ):Container(),



              ],
            ),
          ),
        ),
        prefixIcon: widget.activePrefix.isEmpty
            ? null
            : Container(
          width: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                widget.focus == null
                    ? widget.focusNode!.hasFocus
                    ? widget.activePrefix
                    : widget.inActivePrefix
                    : widget.focus!
                    ? widget.activePrefix
                    : widget.inActivePrefix,
                color: widget.iconColor!, ),
            ],
          ),
        ),
        hintText: widget.boarder? widget.hint:'',
        hintStyle: widget.hintStyle == null
            ? GoogleFonts.roboto(
          //fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.15,
            fontWeight: FontWeight.w500,
            color: const Color(0xff8f8f8f))
            : widget.hintStyle,
        contentPadding: EdgeInsets.only(
            bottom: 0, top: 0, left: widget.boarder ? 16 : 0.0),
      )
          : InputDecoration.collapsed(
          hintText: widget.hint,
          hintStyle: widget.hintStyle == null
              ? GoogleFonts.roboto(
            //fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.15,
              fontWeight: FontWeight.w500,
              color: const Color(0xff8f8f8f))
              : widget.hintStyle),
      style: widget.textStyle == null
          ? GoogleFonts.roboto(
        //fontWeight: FontWeight.bold,
          fontSize: 15,
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500,
          color: textColor)
          : widget.textStyle,
    );
  }
}
