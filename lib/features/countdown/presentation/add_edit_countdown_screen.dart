import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/gaps.dart';
import '../../../core/utils/constants.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../countdown/providers.dart';
import '../../countdown/data/countdown_event.dart';
import '../../../core/navigation/routes.dart';
import '../../notifications/notification_service.dart';

/// Route contract:
/// - Create new: pushNamed(Routes.countdownAddEdit)
/// - Edit existing: pushNamed(Routes.countdownAddEdit, arguments: <eventId:String>)
class AddEditCountdownScreen extends ConsumerStatefulWidget {
  const AddEditCountdownScreen({super.key});

  @override
  ConsumerState<AddEditCountdownScreen> createState() =>
      _AddEditCountdownScreenState();
}

class _AddEditCountdownScreenState
    extends ConsumerState<AddEditCountdownScreen> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _dateUtc;
  String? _emoji;
  CountdownEvent? _editingEvent;

  // reminder offsets in days
  final List<int> _reminders = [];

  bool get _isEditing => _editingEvent != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final eventId = args is String ? args : null;
    if (eventId != null && _editingEvent == null) {
      final repo = ref.read(countdownRepositoryProvider);
      final list = repo.listAll();
      final match =
          list.where((e) => e.id == eventId).toList(); // safe (no .firstOrNull)
      if (match.isNotEmpty) {
        _editingEvent = match.first;
        _title.text = _editingEvent!.title;
        _notes.text = _editingEvent!.notes ?? '';
        _dateUtc = _editingEvent!.dateUtc;
        _emoji = _editingEvent!.emoji;
        _reminders.addAll(_editingEvent!.reminderOffsets);
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final nowLocal = DateTime.now();
    final initial = _dateUtc?.toLocal() ?? nowLocal;
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(nowLocal.year - 1),
      lastDate: DateTime(nowLocal.year + 50),
      initialDate: initial,
    );
    if (picked != null) {
      setState(() {
        _dateUtc = DateTime(picked.year, picked.month, picked.day).toUtc();
      });
    }
  }

  Future<void> _save() async {
    final repo = ref.read(countdownRepositoryProvider);
    final list = repo.listAll();

    if (_title.text.trim().isEmpty) {
      _snack('Please enter a title');
      return;
    }
    if (_dateUtc == null) {
      _snack('Please choose a date');
      return;
    }

    // Free tier caps
    if (!_isEditing && list.length >= kFreeEventCap) {
      if (!mounted) return;
      Navigator.pushNamed(context, Routes.paywall);
      return;
    }
    if (_reminders.length > 1) {
      // Pro only: multiple reminders
      if (!mounted) return;
      Navigator.pushNamed(context, Routes.paywall);
      return;
    }

    final id = _editingEvent?.id ?? UniqueKey().toString();
    final event = CountdownEvent(
      id: id,
      title: _title.text.trim(),
      dateUtc: _dateUtc!,
      emoji: _emoji,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      reminderOffsets: List<int>.from(_reminders),
    );

    if (_isEditing) {
      await repo.update(event);
    } else {
      await repo.add(event);
    }

    // Refresh providers
    ref.invalidate(eventsListProvider);
    ref.invalidate(nearestUpcomingProvider);

    // Schedule (or reschedule) notifications for this event
    await NotificationService.instance.rescheduleForEvent(event);

    if (!mounted) return;
    _snack(_isEditing ? 'Saved changes' : 'Countdown added');
    Navigator.pop(context);
  }

  void _toggleReminder(int offset) {
    setState(() {
      if (_reminders.contains(offset)) {
        _reminders.remove(offset);
      } else {
        _reminders.add(offset);
      }
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Countdown' : 'New Countdown'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(
            controller: _title,
            label: 'Title',
            hint: 'e.g. Birthday Party',
            textInputAction: TextInputAction.next,
          ),
          gap16,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _pickDate,
            child: AbsorbPointer(
              child: AppTextField(
                controller: TextEditingController(
                  text: _dateUtc == null
                      ? ''
                      : formatDateLocalized(_dateUtc!, locale),
                ),
                label: 'Date',
                hint: 'Select a date',
                readOnly: true,
                trailing: const Icon(Icons.calendar_today_outlined),
              ),
            ),
          ),
          gap16,
          Text('Reminders', style: Theme.of(context).textTheme.labelLarge),
          gap8,
          Wrap(
            spacing: 8,
            children: [
              _ReminderChip(
                label: '1d',
                offset: 1,
                selected: _reminders.contains(1),
                onTap: () => _toggleReminder(1),
              ),
              _ReminderChip(
                label: '3d',
                offset: 3,
                selected: _reminders.contains(3),
                onTap: () => _toggleReminder(3),
              ),
              _ReminderChip(
                label: '1w',
                offset: 7,
                selected: _reminders.contains(7),
                onTap: () => _toggleReminder(7),
              ),
              _ReminderChip(
                label: '1m',
                offset: 30,
                selected: _reminders.contains(30),
                onTap: () => _toggleReminder(30),
              ),
              ActionChip(
                label: const Text('+ Custom'),
                onPressed: () {
                  // Pro-gated (later implement a real custom offset dialog)
                  Navigator.pushNamed(context, Routes.paywall);
                },
              ),
            ],
          ),
          gap16,
          Text('Icon', style: Theme.of(context).textTheme.labelLarge),
          gap8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              '🎉', '🎂', '✈️', '📺', '🎵', '💖', '📷', '🎓', '🗓️',
              '🏖️', '🎄', '🎬', '☕', '💪'
            ].map((e) => _EmojiChip(emoji: e)).toList(),
          ),
          gap16,
          AppTextField(
            controller: _notes,
            label: 'Notes',
            hint: 'Optional notes…',
            maxLines: 4,
          ),
          gap24,
          AppButton(
            label: _isEditing ? 'Save Changes' : 'Save Countdown',
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _ReminderChip extends StatelessWidget {
  final String label;
  final int offset;
  final bool selected;
  final VoidCallback onTap;

  const _ReminderChip({
    required this.label,
    required this.offset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _EmojiChip extends ConsumerWidget {
  final String emoji;
  const _EmojiChip({required this.emoji});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        context.findAncestorStateOfType<_AddEditCountdownScreenState>();
    final selected = state?._emoji == emoji;
    return ChoiceChip(
      label: Text(emoji, style: const TextStyle(fontSize: 18)),
      selected: selected,
      onSelected: (_) => state?.setState(() => state._emoji = emoji),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
