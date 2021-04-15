import 'package:coingecko_dart/dataClasses/PricedCoinBase.dart';

class SimpleToken extends PricedCoinBase{
  String contractAddress = "0x";

  ///used to add two instances of the same token with different sets of currency:price data.
  SimpleToken add(SimpleToken token) {
    if (this.contractAddress == token.contractAddress) {
      this.data.addAll(token.data);
    }
    return this; //not add-able
  }

  SimpleToken.fromJson(String contractAddress,Map<String, dynamic> json) : super.fromJson(json) {
    this.contractAddress = contractAddress;
  }
}
