mixin UdyamValidator {
  String? udyamNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Udyam number is required";
    }
    if (!RegExp(r'^[A-Za-z]{5}-[A-Za-z]{2}-\d{2}-\d{7}$').hasMatch(value)) {
      return "Enter a valid Udyam number";
    }
    return null;
  }
}
