import 'package:quiver/core.dart';

import 'coins.dart';

class SearchTrending {
	List<Coins>? coins;
	List<dynamic>? exchanges;

	SearchTrending({this.coins, this.exchanges});

  bool get isNull => coins == null && exchanges == null;

	@override
	String toString() {
		return 'SearchTrending(coins: $coins, exchanges: $exchanges)';
	}

	factory SearchTrending.fromJson(Map<String, dynamic> json) {
		return SearchTrending(
			coins: (json['coins'] as List<dynamic>?)
					?.map((e) => Coins.fromJson(e as Map<String, dynamic>))
					.toList(),
			exchanges: json['exchanges'] as List<dynamic>?,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'coins': coins?.map((e) => e.toJson()).toList(),
			'exchanges': exchanges,
		};
	}	

	SearchTrending copyWith({
		List<Coins>? coins,
		List<dynamic>? exchanges,
	}) {
		return SearchTrending(
			coins: coins ?? this.coins,
			exchanges: exchanges ?? this.exchanges,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is SearchTrending &&
			identical(o.coins, coins) &&
			identical(o.exchanges, exchanges);

	@override
	int get hashCode => hashObjects([coins, exchanges]);
}
