class APIResponse{
  final String msg;
  final String desc;
  final List<Map<String, String>> data;

  APIResponse({required this.msg, required this.desc, required this.data});
}