import 'package:coingecko_dart/helperClass/staticHelpers.dart';
import 'package:quiver/core.dart';

class Exchange {
  String? id;
  String? name;
  int? yearEstablished;
  String? country;
  dynamic description;
  String? url;
  String? image;
  bool? hasTradingIncentive;
  int? trustScore;
  int? trustScoreRank;
  double? tradeVolume24hBtc;
  double? tradeVolume24hBtcNormalized;
  Map<String, dynamic> json = {};

  Exchange(
      {this.id,
      this.name,
      this.yearEstablished,
      this.country,
      this.description,
      this.url,
      this.image,
      this.hasTradingIncentive,
      this.trustScore,
      this.trustScoreRank,
      this.tradeVolume24hBtc,
      this.tradeVolume24hBtcNormalized,
      required json}) {
    this.json = json;
  }

  @override
  String toString() {
    return 'Exchange(id: $id, name: $name, yearEstablished: $yearEstablished, country: $country, description: $description, url: $url, image: $image, hasTradingIncentive: $hasTradingIncentive, trustScore: $trustScore, trustScoreRank: $trustScoreRank, tradeVolume24hBtc: $tradeVolume24hBtc, tradeVolume24hBtcNormalized: $tradeVolume24hBtcNormalized)';
  }

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'] as String?,
      name: json['name'] as String?,
      yearEstablished: json['year_established'] as int?,
      country: json['country'] as String?,
      description: json['description'],
      url: json['url'] as String?,
      image: json['image'] as String?,
      hasTradingIncentive: json['has_trading_incentive'] as bool?,
      trustScore: json['trust_score'] as int?,
      trustScoreRank: json['trust_score_rank'] as int?,
      tradeVolume24hBtc:
          StaticHelpers.checkDouble(json['trade_volume_24h_btc'], null),
      tradeVolume24hBtcNormalized: StaticHelpers.checkDouble(
          json['trade_volume_24h_btc_normalized'], null),
      json: json
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'year_established': yearEstablished,
      'country': country,
      'description': description,
      'url': url,
      'image': image,
      'has_trading_incentive': hasTradingIncentive,
      'trust_score': trustScore,
      'trust_score_rank': trustScoreRank,
      'trade_volume_24h_btc': tradeVolume24hBtc,
      'trade_volume_24h_btc_normalized': tradeVolume24hBtcNormalized,
    };
  }

  Exchange copyWith({
    String? id,
    String? name,
    int? yearEstablished,
    String? country,
    dynamic description,
    String? url,
    String? image,
    bool? hasTradingIncentive,
    int? trustScore,
    int? trustScoreRank,
    double? tradeVolume24hBtc,
    double? tradeVolume24hBtcNormalized,
    Map<String,dynamic> json=const{}
  }) {
    return Exchange(
      id: id ?? this.id,
      name: name ?? this.name,
      yearEstablished: yearEstablished ?? this.yearEstablished,
      country: country ?? this.country,
      description: description ?? this.description,
      url: url ?? this.url,
      image: image ?? this.image,
      hasTradingIncentive: hasTradingIncentive ?? this.hasTradingIncentive,
      trustScore: trustScore ?? this.trustScore,
      trustScoreRank: trustScoreRank ?? this.trustScoreRank,
      tradeVolume24hBtc: tradeVolume24hBtc ?? this.tradeVolume24hBtc,
      tradeVolume24hBtcNormalized:
          tradeVolume24hBtcNormalized ?? this.tradeVolume24hBtcNormalized,
      json: json
    );
  }

  @override
  bool operator ==(Object o) =>
      o is Exchange &&
      identical(o.id, id) &&
      identical(o.name, name) &&
      identical(o.yearEstablished, yearEstablished) &&
      identical(o.country, country) &&
      identical(o.description, description) &&
      identical(o.url, url) &&
      identical(o.image, image) &&
      identical(o.hasTradingIncentive, hasTradingIncentive) &&
      identical(o.trustScore, trustScore) &&
      identical(o.trustScoreRank, trustScoreRank) &&
      identical(o.tradeVolume24hBtc, tradeVolume24hBtc) &&
      identical(o.tradeVolume24hBtcNormalized, tradeVolume24hBtcNormalized);

  @override
  int get hashCode {
    return hashObjects([
      id,
      name,
      yearEstablished,
      country,
      description,
      url,
      image,
      hasTradingIncentive,
      trustScore,
      trustScoreRank,
      tradeVolume24hBtc,
      tradeVolume24hBtcNormalized
    ]);
  }
}
