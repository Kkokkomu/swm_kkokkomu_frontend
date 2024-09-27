import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final Widget? helper;
  final Widget? errorMessage;
  final int? maxLength;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function()? onTap;
  final bool autofocus;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.controller,
    this.autovalidateMode,
    this.helper,
    this.errorMessage,
    this.maxLength,
    this.suffixIcon,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isFocused = false;
  bool? isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: CustomTextStyle.body1Bold(),
        ),
        const SizedBox(height: 8.0),
        Focus(
          onFocusChange: (bool hasFocus) =>
              setState(() => isFocused = hasFocus),
          child: TextFormField(
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            focusNode: widget.focusNode,
            controller: widget.controller,
            autovalidateMode: widget.autovalidateMode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            validator: widget.validator != null
                ? (value) {
                    final resp = widget.validator!(value);
                    isError = resp != null;
                    return resp;
                  }
                : null,
            initialValue: widget.initialValue,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
              // 글자 수 표시를 위해 setState() 호출
              if (widget.maxLength != null) {
                setState(() {});
              }
            },
            onSaved: widget.onSaved,
            cursorColor: ColorName.blue500,
            cursorErrorColor: ColorName.error500,
            style: CustomTextStyle.detail1Reg(
              color: ColorName.gray600,
              decorationThickness: 0.0,
            ),
            autofocus: widget.autofocus,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              suffixIcon: isFocused ? widget.suffixIcon : null,
              suffixIconConstraints:
                  widget.suffixIcon != null ? const BoxConstraints() : null,
              counterText: '',
              errorText: widget.errorMessage != null ? '' : null,
              isDense: true,
              contentPadding: const EdgeInsets.all(12.0),
              filled: true,
              fillColor: ColorName.gray50,
              hintText: widget.hintText,
              hintStyle: CustomTextStyle.detail1Reg(color: ColorName.gray200),
              prefixIcon: widget.prefixIcon,
              errorStyle: const TextStyle(
                color: Colors.transparent,
                fontSize: 0.0,
                height: 0.01,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color: ColorName.blue500,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color: ColorName.error500,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color: ColorName.error500,
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.helper ?? const SizedBox(),
            Expanded(
              child: widget.errorMessage ??
                  (widget.maxLength != null
                      ? Text.rich(
                          textAlign: TextAlign.end,
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                child: SizedBox(height: 24.0),
                                alignment: PlaceholderAlignment.middle,
                              ),
                              TextSpan(
                                text:
                                    '${widget.controller?.text.length ?? 0}/${widget.maxLength}',
                                style: CustomTextStyle.detail3Reg(
                                  color: isError == null
                                      ? ColorName.gray300
                                      : isError!
                                          ? ColorName.error500
                                          : ColorName.blue500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox()),
            ),
          ],
        ),
      ],
    );
  }
}
