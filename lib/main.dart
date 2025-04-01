import 'package:flutter/material.dart';

import 'controller/form_controller.dart';
import 'model/form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Sheet Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  bool isLoading = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      FeedbackForm feedbackForm = FeedbackForm(
        nameController.text,
        emailController.text,
        mobileNoController.text,
        feedbackController.text,
      );

      FormController formController = FormController((String response) {
        setState(() => isLoading = false);

        String message = (response == FormController.STATUS_SUCCESS)
            ? "Feedback Submitted Successfully!"
            : "Error Occurred!";

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });

      formController.submitForm(feedbackForm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Sheet Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(nameController, "Name"),
              _buildTextField(emailController, "Email", isEmail: true),
              _buildTextField(mobileNoController, "Mobile No", isNumber: true),
              _buildTextField(feedbackController, "Feedback",
                  isMultiline: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit Feedback"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isEmail = false,
    bool isNumber = false,
    bool isMultiline = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isNumber
              ? TextInputType.number
              : isMultiline
                  ? TextInputType.multiline
                  : TextInputType.text,
      maxLines: isMultiline ? 3 : 1,
      validator: (value) {
        if (value == null || value.isEmpty) return "Enter valid $label";
        if (isEmail && !value.contains("@")) return "Enter a valid email";
        if (isNumber && value.length != 10) return "Enter a 10-digit number";
        return null;
      },
    );
  }
}
