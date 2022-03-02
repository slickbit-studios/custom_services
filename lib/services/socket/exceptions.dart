class SocketException {
  final String message;
  final String? url;

  const SocketException({required this.message, this.url});

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("SocketException");
    if (message.isNotEmpty) {
      sb.write(": $message");
    }
    if (url != null) {
      sb.write(", url = $url");
    }
    return sb.toString();
  }
}
