import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/model/user_model.dart';
import 'package:pocket_fm_demo/presentation/home/home_screen.dart';
import 'package:pocket_fm_demo/presentation/widget/primary_button.dart';
import 'package:pocket_fm_demo/presentation/widget/primary_textfield.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Personal Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              UserModel user = UserModel(
                firstName: 'Guest',
                lastName: '',
                email: 'guest@gmail.com',
                phone: '9999999999',
              );
              hiveService.addValue(key: 'user', value: user.toJson());
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            child: Text('Skip', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              PrimaryTextfield(
                controller: firstNameController,
                hintText: 'First Name',
                labelText: 'First Name',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Name is required';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              PrimaryTextfield(
                controller: lastNameController,
                hintText: 'Last Name',
                labelText: 'Last Name',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              PrimaryTextfield(
                controller: emailController,
                hintText: 'Email',
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }

                  if (!isValidEmail(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              PrimaryTextfield(
                controller: phoneController,
                hintText: 'Phone',
                labelText: 'Phone',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: PrimaryButton(
                    text: 'Save',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        UserModel user = UserModel(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                        hiveService.addValue(key: 'user', value: user.toJson());
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    isLoading: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
