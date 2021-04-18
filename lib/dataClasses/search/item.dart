

import 'package:quiver/core.dart';

class Item {
	String? id;
	String? name;
	String? symbol;
	int? marketCapRank;
	String? thumb;
	String? large;
	int? score;

	Item({
		this.id,
		this.name,
		this.symbol,
		this.marketCapRank,
		this.thumb,
		this.large,
		this.score,
	});

	@override
	String toString() {
		return 'Item(id: $id, name: $name, symbol: $symbol, marketCapRank: $marketCapRank, thumb: $thumb, large: $large, score: $score)';
	}

	factory Item.fromJson(Map<String, dynamic> json) {
		return Item(
			id: json['id'] as String?,
			name: json['name'] as String?,
			symbol: json['symbol'] as String?,
			marketCapRank: json['market_cap_rank'] as int?,
			thumb: json['thumb'] as String?,
			large: json['large'] as String?,
			score: json['score'] as int?,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'symbol': symbol,
			'market_cap_rank': marketCapRank,
			'thumb': thumb,
			'large': large,
			'score': score,
		};
	}	

	Item copyWith({
		String? id,
		String? name,
		String? symbol,
		int? marketCapRank,
		String? thumb,
		String? large,
		int? score,
	}) {
		return Item(
			id: id ?? this.id,
			name: name ?? this.name,
			symbol: symbol ?? this.symbol,
			marketCapRank: marketCapRank ?? this.marketCapRank,
			thumb: thumb ?? this.thumb,
			large: large ?? this.large,
			score: score ?? this.score,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is Item &&
			identical(o.id, id) &&
			identical(o.name, name) &&
			identical(o.symbol, symbol) &&
			identical(o.marketCapRank, marketCapRank) &&
			identical(o.thumb, thumb) &&
			identical(o.large, large) &&
			identical(o.score, score);

	@override
	int get hashCode {
		return hashObjects([
			id,
			name,
			symbol,
			marketCapRank,
			thumb,
			large,
			score,
		]);
	}
}
