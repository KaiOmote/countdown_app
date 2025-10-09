// lib/features/settings/paywall_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/gaps.dart';
import '../../widgets/app_button.dart';
import './iap_service.dart'; // same folder as this file

/// Local UI state: prevents double-taps during purchase flow.
final _purchaseBusyProvider = StateProvider<bool>((ref) => false);

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProAsync = ref.watch(isProProvider);
    final busy = ref.watch(_purchaseBusyProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),

      body: isProAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(message: e.toString()),
        data: (isPro) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Hero image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/paywall_hero.png',
                fit: BoxFit.cover, // fills the container neatly
              ),
            ),
            gap24,

            // Title
            Center(
              child: Text(
                isPro ? 'You’re Pro! 🎉' : 'Unlock Pro',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            gap8,
            Center(
              child: Text(
                'Unlock Pro for unlimited events, exclusive themes, and an ad-free experience.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            gap24,

            // Comparison table
            Table(
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.grey.shade300),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                _buildRow('Feature', 'Free', 'Pro', isHeader: true),
                _buildRow('Event Limit', '5', 'Unlimited'),
                _buildRow('Themes', 'Basic', 'Exclusive'),
                _buildRow('Ad-Free', '✕', '✓'),
              ],
            ),
            gap24,

            // CTA button
            AppButton(
              label: isPro
                  ? 'You already have Pro'
                  : (busy ? 'Processing…' : 'Unlock Pro'),
              style: AppButtonStyle.filled,
              onPressed: (isPro || busy)
                  ? null
                  : () async {
                      // prevent double taps
                      ref.read(_purchaseBusyProvider.notifier).state = true;
                      try {
                        final success = await IAPService.purchasePro();
                        if (!context.mounted) return;

                        if (success) {
                          // refresh entitlement state
                          ref.invalidate(isProProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pro unlocked! 🎉')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Purchase cancelled')),
                          );
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchase failed: $e')),
                        );
                      } finally {
                        ref.read(_purchaseBusyProvider.notifier).state = false;
                      }
                    },
            ),
            gap12,
            Center(
              child: Text(
                'One-time purchase ¥1,200 JPY',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            gap24,
            Center(
              child: TextButton(
                onPressed: () async {
                  try {
                    await IAPService.restore();
                    if (context.mounted) {
                      ref.invalidate(isProProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Purchases restored')),
                      );
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Restore failed: $e')),
                    );
                  }
                },
                child: const Text('Restore purchases'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TableRow _buildRow(
    String feature,
    String free,
    String pro, {
    bool isHeader = false,
  }) {
    final style =
        isHeader ? const TextStyle(fontWeight: FontWeight.bold) : const TextStyle();
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(feature, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(free, style: style, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(pro, style: style, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  const _ErrorBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 36),
            gap12,
            Text('Something went wrong.\n$message',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
