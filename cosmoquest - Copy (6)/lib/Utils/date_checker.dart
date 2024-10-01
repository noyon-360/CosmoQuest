extension DateTimeExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return this.year == now.year && this.month == now.month && this.day == now.day;
  }
}
