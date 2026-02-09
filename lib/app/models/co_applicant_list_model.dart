class CoApplicantList {
  final List<CoApplicantDetail> coApplicantDetails;

  CoApplicantList({required this.coApplicantDetails});

  factory CoApplicantList.fromJson(Map<String, dynamic> json) {
    return CoApplicantList(
      coApplicantDetails: (json['coApplicantDetails'] as List<dynamic>?)
              ?.map((item) => CoApplicantDetail.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coApplicantDetails':
          coApplicantDetails.map((item) => item.toJson()).toList(),
    };
  }
}

class CoApplicantDetail {
  final String pan;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String email;
  final String phone;
  final String pincode;
  final String designation;
  final String shareholding;

  CoApplicantDetail({
    required this.pan,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.email,
    required this.phone,
    required this.pincode,
    required this.designation,
    required this.shareholding,
  });

  factory CoApplicantDetail.fromJson(Map<String, dynamic> json) {
    return CoApplicantDetail(
      pan: json['pan'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      dob: json['dob'],
      email: json['email'],
      phone: json['phone'],
      pincode: json['pincode'],
      designation: json['designation'],
      shareholding: json['shareholding'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pan': pan,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob.split("/").reversed.join("-"),
      'email': email,
      'phone': phone,
      'pincode': pincode,
      "ownerShipDetails": {
        "designation": designation,
        "shareholding": shareholding,
      }
    };
  }
}
