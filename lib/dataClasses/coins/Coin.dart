class Coin {
  Map<String, dynamic> raw = {};
  String id = "-1", symbol = "-1", name = "-1";

  Coin(
      {String id = "bitcoin", String symbol = "btc", String name = "bitcoin"}) {
    raw = {"id": id, "symbol": symbol, "name": name};
    this.id = id;
    this.symbol = symbol;
    this.name = name;
  }

  @override
  String toString() {
    return "ID: $id, SYMBOL: $symbol, NAME: $name";
  }

  Coin.fromJson(Map<String, dynamic> json) {
    raw = json;
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    raw['id'] = id;
    raw['symbol'] = symbol;
    raw['name'] = name;
    return raw;
  }

  bool isError(){
    return id=="-1" && symbol=="-1" && name=="-1";
  }
  bool get isNull{
    return id=="-1" && symbol=="-1" && name=="-1";
  }
}
