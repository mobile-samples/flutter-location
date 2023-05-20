abstract class ReactionService  {
  Future<int>  setUseful(String id,String author ,String? userId) ;
  Future<int>  removeUseful(String id, String author, String? userId);
}
