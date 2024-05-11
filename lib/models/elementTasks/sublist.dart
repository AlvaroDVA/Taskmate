class Sublist {

  String text;
  bool isChecked;

  Sublist ({
    required this.text,
    required this.isChecked
  });

  factory Sublist.fromJson(Map<String, dynamic> json) {
    return Sublist(
        text: json['text'],
        isChecked: json['isChecked']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text' : text,
      'isChecked' : isChecked
    };
  }

}