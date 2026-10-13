# Q2 — List observations

Manual observations are sufficient. Do not invent timings or frame-rate numbers.

Browser or device / OS:
Flutter version:
Build mode (debug is acceptable):
Dataset: 500 conversations

After Q1, try the eager list once before replacing it. Then repeat the same actions
with the lazy list: load, scroll down and back, search `Contact 0499`, clear search,
open a row, and return. Use the same environment and dataset for both versions.

| Check | Before: eager list | After: lazy list |
| --- | --- | --- |
| When are row widgets created? | | |
| Is a full-list total calculated inside each row? | | |
| Is sorting repeated in the widget build method? | | |
| What did you observe while scrolling? | | |
| What did you observe during search and clearing? | | |
| Does opening a row still update only its unread count? | | |

Why this change helps as the list grows:
Any limitations or things not measured:

It is fine to report no noticeable speed difference. Explain the row-creation
behavior from the code. DevTools traces and physical-device profiling are optional.
