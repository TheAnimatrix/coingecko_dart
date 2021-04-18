import 'item.dart';

class Coins {
	Item? item;

	Coins({this.item});

	@override
	String toString() => 'Coins(item: $item)';

	factory Coins.fromJson(Map<String, dynamic> json) {
		return Coins(
			item: json['item'] == null
					? null
					: Item.fromJson(json['item'] as Map<String, dynamic>),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'item': item?.toJson(),
		};
	}	

	Coins copyWith({
		Item? item,
	}) {
		return Coins(
			item: item ?? this.item,
		);
	}

	@override
	bool operator ==(Object o) => o is Coins && identical(o.item, item);

	@override
	int get hashCode => item.hashCode;
}
