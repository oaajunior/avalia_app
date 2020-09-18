import 'package:flutter/material.dart';

class LayoutTextFields {
  static Widget customTextFields({
    Key key,
    FocusNode focusNode,
    Function onFieldSubmitted,
    TextInputAction textInputAction = TextInputAction.next,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Function onSaved,
    bool enableSuggestions = false,
    TextAlign textAlign = TextAlign.center,
    bool autocorrect = false,
    TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    Function validator,
    TextStyle textStyle = const TextStyle(fontSize: 18),
    bool obscureText = false,
    InputDecoration decoration,
    bool enableInteractiveSelection = true,
  }) {
    Widget textFormField = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 8,
      ),
      child: TextFormField(
        key: key,
        focusNode: focusNode,
        enableInteractiveSelection: enableInteractiveSelection,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        enableSuggestions: enableSuggestions,
        onSaved: onSaved,
        textAlign: textAlign,
        autocorrect: autocorrect,
        style: textStyle,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: decoration,
      ),
    );
    return textFormField;
  }
}
