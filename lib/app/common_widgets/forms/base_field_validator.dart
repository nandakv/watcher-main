mixin BaseFieldValidators {
  bool isFieldValid(
    String? errorMessage,
  ) {
    return errorMessage?.isEmpty ?? true;
  }
}
