import 'package:flutter/material.dart';
import 'inbox_controller.dart';
import 'repository.dart';
import 'thread.dart';

void main() => runApp(InboxApp(
        repository: DemoRepository(
      count: const int.fromEnvironment('THREAD_COUNT', defaultValue: 30),
      failFirst: const bool.fromEnvironment('FAIL_FIRST'),
    )));

class InboxApp extends StatelessWidget {
  const InboxApp({super.key, required this.repository});
  final InboxRepository repository;
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: InboxScreen(repository: repository),
      );
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key, required this.repository});
  final InboxRepository repository;
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late final InboxController controller;
  @override
  void initState() {
    super.initState();
    controller = InboxController(widget.repository);
    controller.load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final threads = controller.visible.toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return Scaffold(
            appBar: AppBar(
                title: Text('Inbox · ${controller.unreadTotal} unread'),
                actions: [
                  IconButton(
                      key: const Key('refresh'),
                      tooltip: 'Refresh',
                      onPressed: controller.loading ? null : controller.load,
                      icon: const Icon(Icons.refresh))
                ]),
            body: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    key: const Key('search'),
                    decoration: const InputDecoration(
                        labelText: 'Search messages',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search)),
                    onChanged: controller.search,
                  )),
              if (controller.loading)
                const LinearProgressIndicator(key: Key('loading')),
              if (controller.error != null)
                Row(children: [
                  Expanded(
                      child: Text(controller.error!, key: const Key('error'))),
                  TextButton(
                      key: const Key('retry'),
                      onPressed: controller.loading ? null : controller.load,
                      child: const Text('Retry')),
                ]),
              SizedBox(
                  child: threads.isEmpty
                      ? Center(
                          child: Text(
                              controller.loading
                                  ? 'Loading inbox…'
                                  : controller.error != null
                                      ? 'Inbox unavailable'
                                      : 'No conversations',
                              key: const Key('empty')))
                      : SingleChildScrollView(
                          key: const Key('thread-list'),
                          child: Column(
                              children: threads
                                  .map((thread) => ListTile(
                                        key: ValueKey(thread.id),
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.person_outline)),
                                        title: Text(thread.name),
                                        subtitle: Text(thread.preview,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        trailing: Text(
                                            '${thread.unread} / ${controller.visible.fold<int>(0, (sum, t) => sum + t.unread)}'),
                                        onTap: () {
                                          controller.markRead(thread.id);
                                          Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                  builder: (_) =>
                                                      ConversationScreen(
                                                          thread: thread)));
                                        },
                                      ))
                                  .toList()),
                        )),
            ]),
          );
        },
      );
}

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key, required this.thread});
  final ChatThread thread;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(thread.name)),
        body: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
                thread.preview.isEmpty ? 'No message preview' : thread.preview,
                key: const Key('conversation-message'))),
      );
}
