class DateFormatter {
  static String time(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  static String twoDigits(int n) => n.toString().padLeft(2, '0');
}
