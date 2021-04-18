
import 'package:coingecko_dart/helperClass/staticHelpers.dart';
import 'package:quiver/core.dart';

class GlobalDefi {
	double? defiMarketCap;
	double? ethMarketCap;
	double? defiToEthRatio;
	double? tradingVolume24h;
	double? defiDominance;
	String? topCoinName;
	double? topCoinDefiDominance;

	GlobalDefi({
		this.defiMarketCap,
		this.ethMarketCap,
		this.defiToEthRatio,
		this.tradingVolume24h,
		this.defiDominance,
		this.topCoinName,
		this.topCoinDefiDominance,
	});

	@override
	String toString() {
		return 'GlobalDefi(defiMarketCap: $defiMarketCap, ethMarketCap: $ethMarketCap, defiToEthRatio: $defiToEthRatio, tradingVolume24h: $tradingVolume24h, defiDominance: $defiDominance, topCoinName: $topCoinName, topCoinDefiDominance: $topCoinDefiDominance)';
	}

  bool get isNull => topCoinName == null;

	factory GlobalDefi.fromJson(Map<String, dynamic> json) {
    json = json['data']??{};
		return GlobalDefi(
			defiMarketCap: StaticHelpers.checkDouble(json['defi_market_cap'],null),
			ethMarketCap: StaticHelpers.checkDouble(json['eth_market_cap'],null),
			defiToEthRatio: StaticHelpers.checkDouble(json['defi_to_eth_ratio'],null),
			tradingVolume24h: StaticHelpers.checkDouble(json['trading_volume_24h'],null),
			defiDominance: StaticHelpers.checkDouble(json['defi_dominance'],null),
			topCoinName: json['top_coin_name'] as String?,
			topCoinDefiDominance: StaticHelpers.checkDouble(json['top_coin_defi_dominance'], null),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'defi_market_cap': defiMarketCap,
			'eth_market_cap': ethMarketCap,
			'defi_to_eth_ratio': defiToEthRatio,
			'trading_volume_24h': tradingVolume24h,
			'defi_dominance': defiDominance,
			'top_coin_name': topCoinName,
			'top_coin_defi_dominance': topCoinDefiDominance,
		};
	}	

	GlobalDefi copyWith({
		double? defiMarketCap,
		double? ethMarketCap,
		double? defiToEthRatio,
		double? tradingVolume24h,
		double? defiDominance,
		String? topCoinName,
		double? topCoinDefiDominance,
	}) {
		return GlobalDefi(
			defiMarketCap: defiMarketCap ?? this.defiMarketCap,
			ethMarketCap: ethMarketCap ?? this.ethMarketCap,
			defiToEthRatio: defiToEthRatio ?? this.defiToEthRatio,
			tradingVolume24h: tradingVolume24h ?? this.tradingVolume24h,
			defiDominance: defiDominance ?? this.defiDominance,
			topCoinName: topCoinName ?? this.topCoinName,
			topCoinDefiDominance: topCoinDefiDominance ?? this.topCoinDefiDominance,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is GlobalDefi &&
			identical(o.defiMarketCap, defiMarketCap) &&
			identical(o.ethMarketCap, ethMarketCap) &&
			identical(o.defiToEthRatio, defiToEthRatio) &&
			identical(o.tradingVolume24h, tradingVolume24h) &&
			identical(o.defiDominance, defiDominance) &&
			identical(o.topCoinName, topCoinName) &&
			identical(o.topCoinDefiDominance, topCoinDefiDominance);

	@override
	int get hashCode {
		return hashObjects([
			defiMarketCap,
			ethMarketCap,
			defiToEthRatio,
			tradingVolume24h,
			defiDominance,
			topCoinName,
			topCoinDefiDominance,
    ]);
	}
}
