class CityAndStateModel {
  List<String>? andamanAndNicobarIslands;
  List<String>? andhraPradesh;
  List<String>? arunachalPradesh;
  List<String>? assam;
  List<String>? bihar;
  List<String>? chandigarh;
  List<String>? chhattisgarh;
  List<String>? dadraAndNagarHaveli;
  List<String>? delhi;
  List<String>? goa;
  List<String>? gujarat;
  List<String>? haryana;
  List<String>? himachalPradesh;
  List<String>? jammuAndKashmir;
  List<String>? jharkhand;
  List<String>? karnataka;
  List<String>? kerala;
  List<String>? madhyaPradesh;
  List<String>? maharashtra;
  List<String>? manipur;
  List<String>? meghalaya;
  List<String>? mizoram;
  List<String>? nagaland;
  List<String>? odisha;
  List<String>? puducherry;
  List<String>? punjab;
  List<String>? rajasthan;
  List<String>? tamilNadu;
  List<String>? telangana;
  List<String>? tripura;
  List<String>? uttarPradesh;
  List<String>? uttarakhand;
  List<String>? westBengal;

  CityAndStateModel(
      {this.andamanAndNicobarIslands,
        this.andhraPradesh,
        this.arunachalPradesh,
        this.assam,
        this.bihar,
        this.chandigarh,
        this.chhattisgarh,
        this.dadraAndNagarHaveli,
        this.delhi,
        this.goa,
        this.gujarat,
        this.haryana,
        this.himachalPradesh,
        this.jammuAndKashmir,
        this.jharkhand,
        this.karnataka,
        this.kerala,
        this.madhyaPradesh,
        this.maharashtra,
        this.manipur,
        this.meghalaya,
        this.mizoram,
        this.nagaland,
        this.odisha,
        this.puducherry,
        this.punjab,
        this.rajasthan,
        this.tamilNadu,
        this.telangana,
        this.tripura,
        this.uttarPradesh,
        this.uttarakhand,
        this.westBengal});

  CityAndStateModel.fromJson(Map<String, dynamic> json) {
    andamanAndNicobarIslands =
        json['Andaman and Nicobar Islands'].cast<String>();
    andhraPradesh = json['Andhra Pradesh'].cast<String>();
    arunachalPradesh = json['Arunachal Pradesh'].cast<String>();
    assam = json['Assam'].cast<String>();
    bihar = json['Bihar'].cast<String>();
    chandigarh = json['Chandigarh'].cast<String>();
    chhattisgarh = json['Chhattisgarh'].cast<String>();
    dadraAndNagarHaveli = json['Dadra and Nagar Haveli'].cast<String>();
    delhi = json['Delhi'].cast<String>();
    goa = json['Goa'].cast<String>();
    gujarat = json['Gujarat'].cast<String>();
    haryana = json['Haryana'].cast<String>();
    himachalPradesh = json['Himachal Pradesh'].cast<String>();
    jammuAndKashmir = json['Jammu and Kashmir'].cast<String>();
    jharkhand = json['Jharkhand'].cast<String>();
    karnataka = json['Karnataka'].cast<String>();
    kerala = json['Kerala'].cast<String>();
    madhyaPradesh = json['Madhya Pradesh'].cast<String>();
    maharashtra = json['Maharashtra'].cast<String>();
    manipur = json['Manipur'].cast<String>();
    meghalaya = json['Meghalaya'].cast<String>();
    mizoram = json['Mizoram'].cast<String>();
    nagaland = json['Nagaland'].cast<String>();
    odisha = json['Odisha'].cast<String>();
    puducherry = json['Puducherry'].cast<String>();
    punjab = json['Punjab'].cast<String>();
    rajasthan = json['Rajasthan'].cast<String>();
    tamilNadu = json['Tamil Nadu'].cast<String>();
    telangana = json['Telangana'].cast<String>();
    tripura = json['Tripura'].cast<String>();
    uttarPradesh = json['Uttar Pradesh'].cast<String>();
    uttarakhand = json['Uttarakhand'].cast<String>();
    westBengal = json['West Bengal'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaman and Nicobar Islands'] = andamanAndNicobarIslands;
    data['Andhra Pradesh'] = andhraPradesh;
    data['Arunachal Pradesh'] = arunachalPradesh;
    data['Assam'] = assam;
    data['Bihar'] = bihar;
    data['Chandigarh'] = chandigarh;
    data['Chhattisgarh'] = chhattisgarh;
    data['Dadra and Nagar Haveli'] = dadraAndNagarHaveli;
    data['Delhi'] = delhi;
    data['Goa'] = goa;
    data['Gujarat'] = gujarat;
    data['Haryana'] = haryana;
    data['Himachal Pradesh'] = himachalPradesh;
    data['Jammu and Kashmir'] = jammuAndKashmir;
    data['Jharkhand'] = jharkhand;
    data['Karnataka'] = karnataka;
    data['Kerala'] = kerala;
    data['Madhya Pradesh'] = madhyaPradesh;
    data['Maharashtra'] = maharashtra;
    data['Manipur'] = manipur;
    data['Meghalaya'] = meghalaya;
    data['Mizoram'] = mizoram;
    data['Nagaland'] = nagaland;
    data['Odisha'] = odisha;
    data['Puducherry'] = puducherry;
    data['Punjab'] = punjab;
    data['Rajasthan'] = rajasthan;
    data['Tamil Nadu'] = tamilNadu;
    data['Telangana'] = telangana;
    data['Tripura'] = tripura;
    data['Uttar Pradesh'] = uttarPradesh;
    data['Uttarakhand'] = uttarakhand;
    data['West Bengal'] = westBengal;
    return data;
  }
}
