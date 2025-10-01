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

/// Route contract:
/// - Create new: pushNamed(Routes.countdownAddEdit)
/// - Edit existing: pushNamed(Routes.countdownAddEdit, arguments: <eventId:String>)
class AddEditCountdownScreen extends ConsumerStatefulWidget {
  final String? eventId; 

  const AddEditCountdownScreen({super.key, this.eventId}); 

  @override
  ConsumerState<AddEditCountdownScreen> createState() => _AddEditCountdownScreenState();
}

class _AddEditCountdownScreenState extends ConsumerState<AddEditCountdownScreen> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _dateUtc;
  String? _emoji; // simple emoji picker MVP

  bool get _isEditing => _editingEvent != null;
  CountdownEvent? _editingEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read optional eventId from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    final eventId = args is String ? args : null;
    if (eventId != null && _editingEvent == null) {
      // repo currently has listAll(); we’ll find by id
      final repo = ref.read(countdownRepositoryProvider);
      final found = repo.listAll().where((e) => e.id == eventId).toList();
      if (found.isNotEmpty) {
        _editingEvent = found.first;
        _title.text = _editingEvent!.title;
        _notes.text = _editingEvent!.notes ?? '';
        _dateUtc = _editingEvent!.dateUtc;
        _emoji = _editingEvent!.emoji;
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
    if (picked == null) return;

    // MVP: date only (00:00), refine to include time later if needed
    final localMidnight = DateTime(picked.year, picked.month, picked.day);
    setState(() {
      _dateUtc = localMidnight.toUtc();
    });
  }

  Future<void> _save() async {
    final repo = ref.read(countdownRepositoryProvider);
    final list = repo.listAll(); // snapshot

    // Validation
    if (_title.text.trim().isEmpty) {
      _snack('Please enter a title');
      return;
    }
    if (_dateUtc == null) {
      _snack('Please choose a date');
      return;
    }

    // Free tier cap only for new events
    final isCreatingNew = !_isEditing;
    if (isCreatingNew && list.length >= kFreeEventCap) {
      // Navigate to paywall on cap
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
    );

    if (_isEditing) {
      await repo.update(event);
    } else {
      await repo.add(event);
    }

    // Invalidate snapshot providers so list/detail refresh when we pop
    ref.invalidate(eventsListProvider);
    ref.invalidate(nearestUpcomingProvider);

    if (!mounted) return;
    _snack(_isEditing ? 'Saved changes' : 'Countdown added');
    Navigator.pop(context);
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
          // Date input (read-only field that opens a date picker)
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
          // Emoji picker MVP — small fixed set
          Text('Icon', style: Theme.of(context).textTheme.labelLarge),
          gap8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const ['🎉', '🎂', '✈️', '📺', '🎵', '💖', '📷', '🎓', '🗓️']
                .map((e) => _EmojiChip(
                      emoji: e,
                      selected: _emoji == e,
                      onSelected: () => setState(() => _emoji = e),
                    ))
                .toList(),
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

class _EmojiChip extends StatelessWidget {
  final String emoji;
  final bool selected;
  final VoidCallback onSelected;

  const _EmojiChip({
    required this.emoji,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(emoji, style: const TextStyle(fontSize: 18)),
      selected: selected,
      onSelected: (_) => onSelected(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

