import 'Coin.dart';

class PricedCoinBase {
  Map<String, double> data = Map();
  DateTime lastUpdatedAtTimeStamp = DateTime.fromMillisecondsSinceEpoch(0);

  ///defaults to epoch

  PricedCoinBase();

  List<String> dataAvailableIn() {
    return data.keys
        .toList()
        .where((element) => element.split('_').length == 1)
        .toList();
  }

  /// used to obtain price of an instance of this crypto-token object
  /// in a currency of choice whose data is available in this instance
  ///
  /// currencies available can be checked by calling token.pricesAvailableIn()
  ///
  /// invalid {token:currency} combo represented by -1 price value;
  double getPriceIn(String vsCurrency) {
    if (dataAvailableIn().contains(vsCurrency)) {
      return data[vsCurrency] ?? 0; //fallback
    } else {
      ///data not available for requested currency in this instance
      return -1;
    }
  }

  double getMarketCapIn(String vsCurrency) {
    if (dataAvailableIn().contains(vsCurrency)) {
      return data["${vsCurrency}_market_cap"] ?? -2;

      ///return market cap if available otherwise -2
    } else {
      ///data not available for requested currency in this instance
      return -1;
    }
  }

  double get24hVolIn(String vsCurrency) {
    if (dataAvailableIn().contains(vsCurrency)) {
      return data["${vsCurrency}_vol"] ?? -2;
    } else {
      ///data not available for requested currency in this instance
      return -1;
    }
  }

  double get24hChangeIn(String vsCurrency) {
    if (dataAvailableIn().contains(vsCurrency)) {
      return data["${vsCurrency}_change"] ?? -2;
    } else {
      ///data not available for requested currency in this instance
      return -1;
    }
  }

  PricedCoinBase.fromJson(Map<String, dynamic> json) {
    for (String key in json.keys) {
      if (key != "last_updated_at") {
        data[key] = (json[key] is double)
            ? json[key]
            : (json[key] is int)
                ? (json[key] as int).toDouble()
                : (json[key] is String)
                    ? double.tryParse(json[key]) ?? -3
                    : -3;

        /// -3 : could not parse value
      } else {
        lastUpdatedAtTimeStamp =
            DateTime.fromMillisecondsSinceEpoch(json["last_updated_at"]);
      }
    }
  }
}
