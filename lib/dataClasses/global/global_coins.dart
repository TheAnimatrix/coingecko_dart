import 'package:quiver/core.dart';

class GlobalCoins {
  int activeCryptocurrencies;
  int? upcomingIcos;
  int? ongoingIcos;
  int? endedIcos;
  int? markets;
  Map<String, dynamic>? totalMarketCap;
  Map<String, dynamic>? totalVolume;
  Map<String, dynamic>? marketCapPercentage;
  double? marketCapChangePercentage24hUsd;
  int? updatedAt;

  bool get isNull => markets == null;

  GlobalCoins({
    this.activeCryptocurrencies=-1,
    this.upcomingIcos,
    this.ongoingIcos,
    this.endedIcos,
    this.markets,
    this.totalMarketCap,
    this.totalVolume,
    this.marketCapPercentage,
    this.marketCapChangePercentage24hUsd,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'GlobalCoins(activeCryptocurrencies: $activeCryptocurrencies, upcomingIcos: $upcomingIcos, ongoingIcos: $ongoingIcos, endedIcos: $endedIcos, markets: $markets, totalMarketCap: $totalMarketCap, totalVolume: $totalVolume, marketCapPercentage: $marketCapPercentage, marketCapChangePercentage24hUsd: $marketCapChangePercentage24hUsd, updatedAt: $updatedAt)';
  }

  factory GlobalCoins.fromJson(Map<String, dynamic> json) {
    json = json['data']??{};
    return GlobalCoins(
      activeCryptocurrencies: json['active_cryptocurrencies'] as int,
      upcomingIcos: json['upcoming_icos'] as int?,
      ongoingIcos: json['ongoing_icos'] as int?,
      endedIcos: json['ended_icos'] as int?,
      markets: json['markets'] as int?,
      totalMarketCap: json['total_market_cap'] == null
          ? null
          : json['total_market_cap'] as Map<String, dynamic>,
      totalVolume: json['total_volume'] == null
          ? null
          : (json['total_volume'] as Map<String, dynamic>),
      marketCapPercentage: json['market_cap_percentage'] == null
          ? null
          : (json['market_cap_percentage'] as Map<String, dynamic>),
      marketCapChangePercentage24hUsd:
          json['market_cap_change_percentage_24h_usd'] as double?,
      updatedAt: json['updated_at'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_cryptocurrencies': activeCryptocurrencies,
      'upcoming_icos': upcomingIcos,
      'ongoing_icos': ongoingIcos,
      'ended_icos': endedIcos,
      'markets': markets,
      'total_market_cap': totalMarketCap??{},
      'total_volume': totalVolume??{},
      'market_cap_percentage': marketCapPercentage??{},
      'market_cap_change_percentage_24h_usd': marketCapChangePercentage24hUsd,
      'updated_at': updatedAt,
    };
  }

  GlobalCoins copyWith({
    int? activeCryptocurrencies,
    int? upcomingIcos,
    int? ongoingIcos,
    int? endedIcos,
    int? markets,
    Map<String,dynamic>? totalMarketCap,
    Map<String,dynamic>? totalVolume,
    Map<String,dynamic>? marketCapPercentage,
    double? marketCapChangePercentage24hUsd,
    int? updatedAt,
  }) {
    return GlobalCoins(
      activeCryptocurrencies:
          activeCryptocurrencies ?? this.activeCryptocurrencies,
      upcomingIcos: upcomingIcos ?? this.upcomingIcos,
      ongoingIcos: ongoingIcos ?? this.ongoingIcos,
      endedIcos: endedIcos ?? this.endedIcos,
      markets: markets ?? this.markets,
      totalMarketCap: totalMarketCap ?? this.totalMarketCap,
      totalVolume: totalVolume ?? this.totalVolume,
      marketCapPercentage: marketCapPercentage ?? this.marketCapPercentage,
      marketCapChangePercentage24hUsd: marketCapChangePercentage24hUsd ??
          this.marketCapChangePercentage24hUsd,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object o) =>
      o is GlobalCoins &&
      identical(o.activeCryptocurrencies, activeCryptocurrencies) &&
      identical(o.upcomingIcos, upcomingIcos) &&
      identical(o.ongoingIcos, ongoingIcos) &&
      identical(o.endedIcos, endedIcos) &&
      identical(o.markets, markets) &&
      identical(o.totalMarketCap, totalMarketCap) &&
      identical(o.totalVolume, totalVolume) &&
      identical(o.marketCapPercentage, marketCapPercentage) &&
      identical(
          o.marketCapChangePercentage24hUsd, marketCapChangePercentage24hUsd) &&
      identical(o.updatedAt, updatedAt);

  @override
  int get hashCode {
    return hashObjects([
      activeCryptocurrencies,
      upcomingIcos,
      ongoingIcos,
      endedIcos,
      markets,
      totalMarketCap,
      totalVolume,
      marketCapPercentage,
      marketCapChangePercentage24hUsd,
      updatedAt,
    ]);
  }
}
