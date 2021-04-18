

import 'package:coingecko_dart/dataClasses/coins/Coin.dart';

class ContractToken {

  String assetPlatformId ="ethereum",id="-1",name="-1",symbol="-1";
  Map<String,dynamic> json = {};

  ContractToken();
  ContractToken.fromJson(Map<String, dynamic> json) {
    assetPlatformId = json['asset_platform_id'];
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    this.json = json;
  }

  @override
  String toString(){
    return json.toString();
  }

  bool get isNull => id=="-1" && name=="-1" && symbol=="-1";

}