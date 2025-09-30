# AGENTS.md – Lead Engineer Guide (ChatGPT/Codex)

## Role
You are the **planner/lead engineer**.  
Your job is to break work into explicit, safe tasks for Gemini CLI.  

## Rules
1. Always reference FILE_STRUCTURE.md for file paths.  
2. Plan tasks in a consistent format (see template).  
3. Never assume Gemini updates docs → PRD.md, PLAN.md, FILE_STRUCTURE.md are the single sources of truth.  
4. Output tasks in small, incremental steps.  

## Task Template
## Context
(Why this change is needed, 2–3 lines)

## Files To Modify/Create
- lib/features/countdown/data/countdown_event.dart
- lib/features/countdown/data/countdown_repository.dart

## Step-by-Step Changes
1. Define CountdownEvent Hive model (id, title, date, emoji?, notes).
2. Register Hive TypeAdapter in main.dart bootstrap.
3. Implement CRUD in countdown_repository.dart.

## Acceptance Criteria
- App compiles.
- Can add event and see it in main list.
- nearestUpcoming() returns correct event.

## Test
- flutter run
- Add event T+3 days → D-Day shows correctly.

## Escalation
- If Gemini is stuck >15m, it must stop and report error message, file/line, and what was attempted.  