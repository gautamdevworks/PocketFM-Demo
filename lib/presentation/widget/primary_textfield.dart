import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_fm_demo/service/theme_provider.dart';
import 'package:provider/provider.dart';

class PrimaryTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? radius;

  const PrimaryTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ?? 8),
      borderSide: BorderSide(color: isDark ? Colors.white70 : Colors.black87),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText.isNotEmpty) ...[
            Text(labelText, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
          ],
          TextFormField(
            inputFormatters: inputFormatters ?? [],
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,

            keyboardType: keyboardType ?? TextInputType.text,
            validator: (value) => validator?.call(value),
            decoration: InputDecoration(
              hintText: hintText,
              border: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              errorBorder: outlineInputBorder,
              disabledBorder: outlineInputBorder,
              contentPadding: EdgeInsets.all(16),
              fillColor: Colors.transparent,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTextfield extends StatelessWidget {
  final Function(String) onChanged;

  const SearchTextfield({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: isDark ? Colors.white70 : Colors.black87),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      child: TextFormField(
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search for products',
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          contentPadding: EdgeInsets.all(16),
          fillColor: Colors.transparent,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
