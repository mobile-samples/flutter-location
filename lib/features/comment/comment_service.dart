import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:http/http.dart' as http;

// class ReplyCommentService {
//   ReplyCommentService._instantiate();
//
//   static final ReplyCommentService instance =
//       ReplyCommentService._instantiate();
//   static final String name = "films";
//   String url = HttpHelper.instance.getUrl() + "/" + name;
//
//   Future<List<FilmCommentReply>> getReply(String id, String author) async {
//     final headers = await HttpHelper.instance.buildHeader();
//
//     final response = await http.post(
//       Uri.parse(
//         url + '/commentthread/' + id + '/reply',
//       ),
//       headers: headers,
//       body: jsonEncode(<String, dynamic>{
//         'author': author,
//       }),
//     );
//     if (response.statusCode == 200) {
//       dynamic data = jsonDecode(response.body);
//       if (data == null) {
//         return List.empty();
//       }
//       List<FilmCommentReply> listReply = List<FilmCommentReply>.from(
//           data.map((x) => FilmCommentReply.fromJson(x)));
//       return listReply;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
//
//   Future<int> postComment(String id, String comment, bool anonymous) async {
//     final storage = new FlutterSecureStorage();
//     late String baseUrl = HttpHelper.instance.getUrl();
//     final userId = await storage.read(key: 'userId');
//     final headers = await HttpHelper.instance.buildHeader();
//     final response = await http.post(
//       Uri.parse(baseUrl + '/films/commentthread/' + id + '/' + (userId ?? '')),
//       headers: headers,
//       body: jsonEncode(
//           <String, dynamic>{'comment': comment, 'anonymous': anonymous}),
//     );
//     if (response.statusCode == 200) {
//       return 1;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
//
//   Future<int> postReply(
//       String id, String commentId, String comment, bool anonymous) async {
//     final storage = new FlutterSecureStorage();
//     final userId = await storage.read(key: 'userId');
//     final headers = await HttpHelper.instance.buildHeader();
//     final response = await http.post(
//       Uri.parse(url +
//           '/commentthread/' +
//           id +
//           '/' +
//           (userId ?? '') +
//           '/reply/' +
//           commentId),
//       headers: headers,
//       body: jsonEncode(
//           <String, dynamic>{'comment': comment, 'anonymous': anonymous}),
//     );
//     if (response.statusCode == 200) {
//       return 1;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
// }

// class FilmCommentService {
//   FilmCommentService._instantiate();
//
//   static final FilmCommentService instance = FilmCommentService._instantiate();
//   static final String name = "films";
//   String url = HttpHelper.instance.getUrl() + "/" + name;
//
//   Future<SearchResult<CommentThread>> search(String id) async {
//     final storage = new FlutterSecureStorage();
//     late String baseUrl = HttpHelper.instance.getUrl();
//     final userId = await storage.read(key: 'userId');
//     final headers = await HttpHelper.instance.buildHeader();
//     final response = await http.post(
//       Uri.parse(baseUrl + '/films/commentthread/search'),
//       headers: headers,
//       body: jsonEncode(<String, dynamic>{
//         'id': id,
//         'limit': 24,
//         'sort': '-time',
//         'userId': userId
//       }),
//     );
//     if (response.statusCode == 200) {
//       dynamic res = jsonDecode(response.body);
//       SearchResult<CommentThread> searchResult = SearchResult.fromJson(res);
//       return searchResult;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
//
//   Future<List<FilmCommentReply>> getReply(String id, String author) async {
//     final headers = await HttpHelper.instance.buildHeader();
//
//     final response = await http.post(
//       Uri.parse(
//         url + '/commentthread/' + id + '/reply',
//       ),
//       headers: headers,
//       body: jsonEncode(<String, dynamic>{
//         'author': author,
//       }),
//     );
//     if (response.statusCode == 200) {
//       dynamic data = jsonDecode(response.body);
//       if (data == null) {
//         return List.empty();
//       }
//       List<FilmCommentReply> listReply = List<FilmCommentReply>.from(
//           data.map((x) => FilmCommentReply.fromJson(x)));
//       return listReply;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
//
//   Future<int> postComment(String id, String comment, bool anonymous) async {
//     final storage = new FlutterSecureStorage();
//     late String baseUrl = HttpHelper.instance.getUrl();
//     final userId = await storage.read(key: 'userId');
//     final headers = await HttpHelper.instance.buildHeader();
//     final response = await http.post(
//       Uri.parse(baseUrl + '/films/commentthread/' + id + '/' + (userId ?? '')),
//       headers: headers,
//       body: jsonEncode(
//           <String, dynamic>{'comment': comment, 'anonymous': anonymous}),
//     );
//     if (response.statusCode == 200) {
//       return 1;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
//
//   Future<int> postUseful(String id, String author, bool useful) async {
//     final storage = new FlutterSecureStorage();
//     late String baseUrl = HttpHelper.instance.getUrl();
//     final userId = await storage.read(key: 'userId');
//     final headers = await HttpHelper.instance.buildHeader();
//     final url = baseUrl +
//         '/films/commentthread/' +
//         id +
//         '/' +
//         author +
//         '/useful/' +
//         (userId ?? '');
//     final response = useful
//         ? await http.post(Uri.parse(url),
//             headers: headers, body: jsonEncode(<dynamic, dynamic>{}))
//         : await http.delete(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200 && json.decode(response.body) > 0) {
//       return 1;
//     } else {
//       print(response.statusCode);
//       print(response.body);
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
//
//   Future<int> postReply(
//       String id, String commentId, String comment, bool anonymous) async {
//     final storage = new FlutterSecureStorage();
//     final userId = await storage.read(key: 'userId');
//     final headers = await HttpHelper.instance.buildHeader();
//     final response = await http.post(
//       Uri.parse(url +
//           '/commentthread/' +
//           id +
//           '/' +
//           (userId ?? '') +
//           '/reply/' +
//           commentId),
//       headers: headers,
//       body: jsonEncode(
//           <String, dynamic>{'comment': comment, 'anonymous': anonymous}),
//     );
//     if (response.statusCode == 200) {
//       return 1;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
// }

class FilmCommentThreadClient implements CommentThreadService {
  FilmCommentThreadClient() : super();

  FilmCommentThreadClient._instantiate();

  static final FilmCommentThreadClient instance =
      FilmCommentThreadClient._instantiate();
  static const String name = "films";
  String url = HttpHelper.instance.getUrl() + "/" + name;

  @override
  Future<int> comment(String id, String comment) async {
    const storage = FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse('$baseUrl/films/commentthread/$id/${userId ?? ''}'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{'comment': comment}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> delete(String commentId, String author) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.delete(
      Uri.parse('$url/commentthread/$commentId/$author'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
      // throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> update(String commentId, String comment, String author) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.patch(
      Uri.parse('$url/commentthread/$commentId/$author'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{"comment": comment}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

class FilmCommentThreadReplyClient implements CommentThreadReplyService {
  FilmCommentThreadReplyClient() : super();

  FilmCommentThreadReplyClient._instantiate();

  static final FilmCommentThreadReplyClient instance =
      FilmCommentThreadReplyClient._instantiate();
  static const String name = "films";
  String url = HttpHelper.instance.getUrl() + "/" + name;

  @override
  Future<int> reply(String id, String commentId, String comment) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse("$url/commentthread/$id/${userId ?? ''}/reply/$commentId"),
      headers: headers,
      body: jsonEncode(<String, dynamic>{'comment': comment}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> delete(
      String commentThreadId, String commentId, String author) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.delete(
      Uri.parse("$url/commentthread/$commentThreadId/reply/$commentId/$author"),
      headers: headers,
      body: jsonEncode(<String, dynamic>{}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> update(String commentId, String comment, String author) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.patch(
      Uri.parse('$url/commentthread/reply/$commentId/$author'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{'comment': comment}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<List<CommentReply>> getComments(String id, String? author) async {
    final headers = await HttpHelper.instance.buildHeader();

    final response = await http.post(
      Uri.parse('$url/commentthread/$id/reply'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'author': author,
      }),
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      if (data == null) {
        return List.empty();
      }
      List<CommentReply> listReply =
          List<CommentReply>.from(data.map((x) => CommentReply.fromJson(x)));
      return listReply;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

abstract class CommentThreadService {
  Future<int> comment(String id, String comment);

  Future<int> delete(String commentId, String author);

  Future<int> update(String commentId, String comment, String author);
}

abstract class CommentThreadReplyService {
  Future<List<CommentReply>> getComments(
      String commentThreadId, String? author);
  Future<int> reply(String id, String commentId, String comment);

  Future<int> delete(String commentThreadId, String commentId, String author);

  Future<int> update(String commentId, String comment, String author);
}
