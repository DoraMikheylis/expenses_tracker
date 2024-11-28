class CurrencyModel {
  String? currency;
  double? value;

  CurrencyModel({this.currency, this.value});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}
