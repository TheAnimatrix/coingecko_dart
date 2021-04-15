

class Coin{

  String id="-1",symbol="-1",name="-1";

  Coin({String id="bitcoin",String symbol="btc",String name="bitcoin"}){
    this.id=id;
    this.symbol=symbol;
    this.name=name;
  }

  @override
  String toString() {
    return "ID: $id, SYMBOL: $symbol, NAME: $name";
    
  }

  Coin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    return data;
  }

}