import 'package:coingecko_dart/helperClass/staticHelpers.dart';

class ExchangeRates {
  List<ExchangeRate> rates = const [];

  ExchangeRates();

  @override
  String toString() {
    return rates.toString();
  }

  ///use returnedValue.getRateOf(input_currency) to obtain btc's value in the input currency
  ExchangeRate getRateOf(String name) {
    if (getVsList().contains(name))
      return rates.firstWhere((element) => element.name == name);
    else
      return ExchangeRate();

    ///result.isNull = true, if input name doesn't exist in obtained rate list.
  }

  ///use returnedValue.getVsList() to obtain other currency names available in list
  List<String> getVsList() {
    var t = rates.map((e) => (e.name != "-1") ? e.name : "").toList();
    t.retainWhere((element) => element.isNotEmpty);
    return t;
  }

  ///use returnedValue.isNull to check if no results were obtained
  bool get isNull => rates.isEmpty;

  ExchangeRates.fromJson(Map<String, dynamic> json) {
    json = json['rates'];
    rates = [];
    for (String key in json.keys) {
      rates.add(ExchangeRate.fromJson(json[key]));
    }
  }
}

class ExchangeRate {
  String name = "-1", unit = "-1", type = "-1";
  double value = -1.0;

  bool get isNull => name == "-1" && unit == "-1";

  ExchangeRate();

  ExchangeRate.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    unit = json['unit'];
    value = StaticHelpers.checkDoubleN(json['value'], -1.0);
    type = json['type'];
  }

  @override
  String toString() {
    return "ExchangeRate(name: $name, unit: $unit, type: $type, value: $value)";
  }
}
