abstract class IStorage <T> {
  Map<String, dynamic> toJson(T item);
  T fromJson (Map<String, dynamic> json);
}