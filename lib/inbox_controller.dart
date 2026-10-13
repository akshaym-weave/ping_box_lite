import 'package:flutter/foundation.dart';
import 'repository.dart';
import 'thread.dart';

class InboxController extends ChangeNotifier {
  InboxController(this.repository);
  final InboxRepository repository;
  List<ChatThread> _all = [];
  List<ChatThread> _visible = [];
  final Set<String> _readIds = {};
  String _query = '';
  bool _disposed = false;
  bool loading = false;
  String? error;
  int unreadTotal = 0;
  List<ChatThread> get visible => List.unmodifiable(_visible);

  Future<void> load() async {
    // Keep requests sequential; repeated refresh taps are ignored during loading.
    if (_disposed || loading) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final List<ChatThread> result = repository.fetch();
      if (_disposed) return;
      _all =
          result.map((t) => _readIds.contains(t.id) ? t.markRead() : t).toList()
            ..sort((a, b) {
              final byTime = b.updatedAt.compareTo(a.updatedAt);
              return byTime != 0 ? byTime : a.id.compareTo(b.id);
            });
      _derive();
    } catch (_) {
      if (_disposed) return;
      error = 'Could not load inbox';
    }

    loading = false;
    notifyListeners();
  }

  void search(String query) {
    final normalized = query.trim().toLowerCase();
    if (_query == normalized) return;
    _query = normalized;
    _derive();
    notifyListeners();
  }

  void markRead(String id) {
    if (!_all.any((t) => t.id == id && t.unread > 0)) return;
    _readIds.add(id);
    _all = _all.map((t) => t.id == id ? t : t.markRead()).toList();
    _derive();
    notifyListeners();
  }

  void _derive() {
    unreadTotal = _all.fold(0, (total, t) => total + t.unread);
    _visible = _all
        .where((t) =>
            t.name.toLowerCase().contains(_query) ||
            t.preview.toLowerCase().contains(_query))
        .toList();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
