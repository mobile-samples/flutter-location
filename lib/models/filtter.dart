
class Filter {
  int? page;
  int? limit;
  int? firstLimit;
  List<String>? fields;
  String? sort;
  String? currentUserId;

  String? q;
  String? keyword;
  List<dynamic>? excluding; // You can use either dynamic, Object, or a custom type for this field.
  String? refId;

  int? pageIndex;
  int? pageSize;
}
