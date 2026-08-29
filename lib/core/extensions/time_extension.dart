extension TimeAgoExtension on DateTime {
  String formatTimeAgo() {
    final localTime = this.toLocal(); // convert 'this' to local

    final diff = DateTime.now().difference(localTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
