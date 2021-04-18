

import 'package:coingecko_dart/helperClass/staticHelpers.dart';
import 'package:intl/intl.dart';

class CoinDataPoint{
  DateTime? date;
  double? price;

  CoinDataPoint.fromArray(List<dynamic> dataPoint) {
    date = DateTime.fromMillisecondsSinceEpoch(dataPoint[0]);
    price = StaticHelpers.checkDouble(dataPoint[1],-1.0);
  }

  bool get isNull => date==null;

  @override
  String toString() {
    return "Date: ${(date!=null)?date!.millisecondsSinceEpoch:null}, Price: $price";
  }

  bool operator ==(o) => o is CoinDataPoint && this.date==o.date && this.price==o.price;

}