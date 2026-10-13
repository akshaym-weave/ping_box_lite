# Flutter inbox exercise — 3–5 years of experience

Improve the supplied offline inbox. Work through Q1–Q3 in order and explain your changes.
Complete the [README setup checklist](README.md#pre-interview-readiness-checklist)
before the round. The starter's compile error is intentional; fix it during Q1.

There are **five coding issue groups**: four in Q1 and one in Q2.
The three tests in Q3 are a separate task.

| Task | Time | Required work |
| --- | ---: | --- |
| Q1 — Debug | 25 min | Four fixes: async loading, parsing, layout, selected read state |
| Q2 — Improve | 10 min | One improvement: build rows lazily |
| Q3 — Test | 20 min | Two logic tests and one widget test |
| Review | 5 min | Explain changes and unfinished work |

**Total: 60 minutes. Setup time is excluded.**

## Q1 — Make the inbox work

Use the default **30 conversations**. Fix these four areas:

1. **Loading:** resolve the analyzer error so repository data loads asynchronously.
2. **Parsing:** accept integer or integer-string unread counts; use 0 for missing,
   invalid, or negative values. Convert a null preview to an empty string.
   Timestamp parsing is already supplied.
3. **Layout:** keep search above a bounded, scrollable list without screen overflow.
4. **Read state:** opening a conversation marks only that row read, opens its preview,
   and updates the header. Opening it again must not change the total.

Preserve these behaviors:

- Search names and previews, ignoring case and surrounding spaces; clearing restores rows.
- Show newest conversations first. The header totals unread messages across the whole
  inbox, including rows hidden by search.
- Keep opened conversations read after refresh within the same app session.
- Keep loading, empty, error, Retry, and Back navigation working. Empty inbox and no
  search matches may share a message. A missing preview displays `No message preview`.

Example: rows have **3 and 2 unread messages**. Opening the first leaves **0 and 2**,
with **2 unread** in the header, even when search hides the second row.

Keep the supplied disposal and sequential-loading safeguards. Check the normal flow,
`THREAD_COUNT=0`, and `FAIL_FIRST=true` followed by Retry.

## Q2 — Improve the list

Run with **500 conversations**:

```sh
flutter run -d chrome --dart-define=THREAD_COUNT=500
```

Build rows lazily with `ListView.builder` or equivalent. Keep every conversation
available through scrolling and search. Each row already shows its own unread count,
and the controller supplies sorted data and the cached header total.

Preserve Q1 behavior. In `PERFORMANCE.md`, describe this change and compare scrolling
and search before/after on the same browser/device and build mode. Manual observations
are enough; reporting no noticeable timing difference is acceptable. Do not invent numbers.

## Q3 — Add three tests

Replace the skipped placeholders in `test/exercise_test.dart`. Use a small fake
`InboxRepository` returning known data through an immediately completed Future.

1. **Logic:** case/space-insensitive search filters correctly; clearing restores rows.
2. **Logic:** with unread counts 3 and 2, opening the first leaves 0 and 2 and total 2.
   Reopening it leaves the total unchanged.
3. **Widget:** load two rows, search, verify only the matching row remains, then clear
   and verify both return. Advance the UI with `pump`/`pumpAndSettle`.

Remove `skip: true` and assert public results. Avoid real-time sleeps and network calls.

## Submit and explain

Submit app changes, three tests, `PERFORMANCE.md` observations, and a brief note about
unfinished work. Run `flutter analyze` and `flutter test` after completing the fixes.

Main files: `lib/main.dart`, `lib/inbox_controller.dart`, and `lib/thread.dart`.
Use the supplied repository. No new state-management package, backend, sending,
persistence, profiling traces, or advanced async tests are required.

Ask for a hint if stuck. The interviewer will state the AI policy before timing starts.
Optional discussion, if time remains: Retry tests, disposal safety, larger-data search,
and navigation tests.
