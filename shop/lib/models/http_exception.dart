

class HttpException implements Exception{
  late final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
