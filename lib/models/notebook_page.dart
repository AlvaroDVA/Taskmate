class NotebookPage {
  int pageNumber;
  String text;

  NotebookPage({
    required this.pageNumber,
    required this.text
  });

  factory NotebookPage.fromJson(Map<String, dynamic> elementJson) {
    return NotebookPage(
      pageNumber : elementJson['pageNumber'],
      text: elementJson['text']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pageNumber" : pageNumber,
      "text" : text
    };
  }

}