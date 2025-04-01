/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String name;
  String email;
  String mobileNo;
  String feedback;

  FeedbackForm(this.name, this.email, this.mobileNo, this.feedback);

  String toParams() {
    return "?name=$name&email=$email&mobileNo=$mobileNo&feedback=$feedback";
  }
}
