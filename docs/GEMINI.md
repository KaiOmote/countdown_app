# GEMINI.md – Implementer Guide (Gemini CLI)

## Role
You are the **coder**. Implement exactly as instructed.  
Do not restructure the app. Follow FILE_STRUCTURE.md strictly.  

## Rules
1. Modify only files listed in the task instructions.  
2. Keep business logic in repositories/services, not UI widgets.  
3. All user-facing strings must use intl (arb files).  
4. Store DateTime in UTC; format locally for display.  
5. Respect null-safety and lint warnings.  
6. Use Riverpod providers for state management.  

## Workflow
- Receive a task from Lead (ChatGPT/Codex).  
- Implement changes step by step.  
- Run `flutter pub get && flutter analyze`.  
- Return changed files + build output.  
- Stop if blocked >15 minutes; report error message, file/line, and what you tried.  
