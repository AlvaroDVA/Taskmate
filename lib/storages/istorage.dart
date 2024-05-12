abstract class IStorage <T> {
  List<T> loadLocalData ();
  bool saveLocalData(List<T> list);
}