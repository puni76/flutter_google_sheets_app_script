import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.

class FormController {
  final void Function(String) callback;

  // Define the API URL here
  static const String API_URL =
      "https://script.google.com/macros/s/AKfycbwkzQjfSPj37llpjFCmS_gOoQI2BOr3Y9ohn52ybBCaO4UTzWUTxhd1aHz1S9USJyKb/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  /// Submit feedback to Google Sheets
  void submitForm(FeedbackForm feedbackForm) async {
    try {
      final url = '$API_URL${feedbackForm.toParams()}';
      print('Requesting URL: $url');

      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Assuming the response is JSON with a 'status' key
        final responseData = convert.jsonDecode(response.body);
        if (responseData['status'] == 'SUCCESS') {
          callback('Success');
        } else {
          callback('Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
