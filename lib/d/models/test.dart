class Test {
	List<dynamic>? stuff;

	Test({this.stuff});

	factory Test.fromJson(Map<String, dynamic> json) {
		return Test(
			stuff: json['stuff'] as List<dynamic>?,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'stuff': stuff,
		};
	}
}
