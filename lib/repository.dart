import 'thread.dart';

abstract class InboxRepository {
  Future<List<ChatThread>> fetch();
}

class DemoRepository implements InboxRepository {
  DemoRepository(
      {this.count = 30,
      this.failFirst = false,
      this.delay = const Duration(milliseconds: 600)});
  final int count;
  final bool failFirst;
  final Duration delay;
  int calls = 0;

  @override
  Future<List<ChatThread>> fetch() async {
    final call = ++calls;
    await Future<void>.delayed(delay);
    if (failFirst && call == 1)
      throw StateError('Simulated unavailable service');
    return List.generate(
        count,
        (i) => ChatThread.fromJson({
              'id': 'thread-$i',
              'name': 'Contact ${i.toString().padLeft(4, '0')}',
              'preview': i % 11 == 0
                  ? null
                  : 'Message $i: Can we review the proposal?',
              'unread': i % 2 == 0 ? '${i % 5}' : i % 5,
              'updatedAt': 1700000000 + i,
            }));
  }
}
