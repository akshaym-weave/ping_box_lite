# Flutter inbox coding exercise — 3–5 years of experience

This is a 90-minute practical round. Improve an existing app; you do not need to
build a new app or introduce a state-management package. Setup time is excluded.

## The app

The inbox has a search field, conversation rows, an unread-message total, and a
conversation preview screen. It uses offline demo data with a short loading delay.
The starter intentionally contains a compile error, parsing errors, a layout bug,
and a selected-conversation read bug. It also does unnecessary work in the list.

Start with the default 30 conversations. Work through Q1, Q2, and Q3 in order.

| Task | Time | Required outcome |
| --- | ---: | --- |
| Q1: Debug the inbox | 35 min | Working async load, parsing, layout, and selected read state |
| Q2: Improve the list | 15 min | Lazy rows without repeated totals or sorting, using 500 conversations |
| Q3: Add tests | 30 min | Two logic tests and one widget test |
| Explain and review | 10 min | Explain changes and any unfinished work |

## Where to work

- `lib/main.dart`: layout, rows, search field, navigation, preview screen.
- `lib/inbox_controller.dart`: loading, search, and unread state.
- `lib/thread.dart`: conversation model and parsing.
- `lib/repository.dart`: offline data source, already supplied.
- `test/exercise_test.dart`: skipped placeholders to replace.
- `PERFORMANCE.md`: short observations for Q2.

## Q1 — Fix loading, parsing, layout, and unread behavior

Start with the analyzer error, then run the app and reproduce the remaining problems.
Fix these four areas:

1. Wait for the repository Future before using its returned conversations.
2. Parse unread counts supplied as integers or integer strings; use 0 for missing,
   invalid, or negative counts. A null preview should become an empty string.
   Timestamp normalization is already supplied.

3. The search field stays above a list that uses the remaining screen space.
   The list scrolls without overflowing the screen.
4. Tapping a conversation marks **only that conversation** read, opens its preview,
   and updates the header total. Going back shows the updated row.

The unread total counts messages across the whole inbox, including rows hidden by
search. For example, two conversations have 3 and 2 unread messages: the header
shows 5. Opening the first changes its count to 0 and the total to 2. Opening it
again leaves the total at 2. Searching for only the first still leaves the total at 2.

Keep the supplied behavior working:

- Search matches contact names or previews, ignoring case and surrounding spaces.
  Clearing search restores all rows.
- Newest conversations appear first.
- Loading, empty inbox, error, and Retry states remain visible when appropriate.
  The same empty message may be used for an empty inbox and no search matches.
- Refresh keeps opened conversations read within the current app session.
- The conversation screen shows the name and latest preview, with a Back action.

The loading/error UI, sequential refresh requests, and disposal safety are provided.
Keep those safeguards while fixing async loading. Explain the four areas you repaired.

Manual checks: load the default dataset, scroll, search, open a row, go back,
clear search, and refresh. Also check `THREAD_COUNT=0` and `FAIL_FIRST=true` with Retry.

## Q2 — Build rows as needed

Run with 500 conversations:

```sh
flutter run -d chrome --dart-define=THREAD_COUNT=500
```

Replace the eager list with `ListView.builder` or an equivalent lazy list. Keep the
bounded layout, navigation, and search behavior from Q1. Also:

- Remove the full-list unread calculation repeated inside each row. A row only needs
  its own unread count; the header already has a cached whole-inbox total.
- Remove sorting from the widget build method. The controller already sorts on load.

In `PERFORMANCE.md`, briefly explain what the old list created, what the new list
creates, which repeated calculations you removed, and what you observed while
scrolling and searching before and after.
A manual comparison on the same browser/device and build mode is enough. If you
cannot notice a timing difference, say so and explain the change in row creation.

DevTools traces, frame-duration calculations, physical-device profiling, isolates,
pagination, and search indexing are not required. Do not invent measurements.

## Q3 — Add three meaningful tests

Replace the skipped placeholders and remove their `skip: true` arguments.
Use a small fake repository returning known conversations. The repository is already
injected into the controller and app. An immediately completed Future is sufficient;
you do not need to control overlapping requests or use real-time sleeps.

Required tests:

1. **Logic:** searching ignores case and surrounding spaces, and clearing the query
   restores the list. Use at least two conversations so filtering is meaningful.
2. **Logic:** opening one conversation marks only it read and updates the unread total.
   Use two conversations with different nonzero counts, such as 3 and 2. Check both
   rows, the total, and that opening the same conversation again leaves the total unchanged.
3. **Widget:** load an inbox with a fake repository, enter a search query, and check
   that the matching row appears and the other row disappears. Clear search and
   check that both return. Use `pump`/`pumpAndSettle` to advance the widget test.

Tests should assert public behavior and fail when the relevant behavior breaks.
A fake returning `Future.value(...)` keeps tests fast and repeatable. No network,
platform plugins, coverage target, or minimum test count beyond these three is required.

## Optional discussion — only if time remains

These are bonus topics, not requirements for passing:

- How would you test loading failure and Retry?
- What happens if a request finishes after the screen is removed?
- What could you investigate if search became slow with a much larger dataset?
- How would you test opening a conversation and returning to the inbox?

Do not implement extra features at the expense of the required tasks. Sending,
message history, authentication, real APIs, persistence, and architecture rewrites
are outside the exercise.

## Submission

Submit updated code, the three tests, a short `PERFORMANCE.md` observation, and a
brief note about unfinished work. Run `flutter analyze` and `flutter test`.
Explain your changes during review. The interviewer will state the AI-assistance
policy before timing starts. If you get stuck, ask for a hint; partial work is reviewed.
