// lib/features/settings/paywall_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_app/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
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
                isPro ? l10n.proThanks : l10n.paywallUnlockTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            gap8,
            Center(
              child: Text(
                l10n.paywallSubtitle,
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
                _buildRow(
                  l10n.paywallFeatureHeader,
                  l10n.paywallFreeColumn,
                  l10n.paywallProColumn,
                  isHeader: true,
                ),
                _buildRow(
                  l10n.paywallFeatureEventLimit,
                  '5',
                  l10n.paywallEventLimitPro,
                ),
                _buildRow(
                  l10n.paywallFeatureThemes,
                  l10n.paywallThemeFree,
                  l10n.paywallThemePro,
                ),
                _buildRow(
                  l10n.paywallFeatureAdFree,
                  l10n.paywallAdFreeFree,
                  l10n.paywallAdFreePro,
                ),
              ],
            ),
            gap24,

            // CTA button
            AppButton(
              label: isPro
                  ? l10n.paywallAlreadyPro
                  : (busy ? l10n.paywallProcessing : l10n.upgradePro),
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
                            SnackBar(
                              content: Text(l10n.paywallPurchaseSuccess),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.paywallPurchaseCancelled),
                            ),
                          );
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.paywallPurchaseFailed(e.toString()),
                            ),
                          ),
                        );
                      } finally {
                        ref.read(_purchaseBusyProvider.notifier).state = false;
                      }
                    },
            ),
            gap12,
            Center(
              child: Text(
                l10n.paywallOneTimePrice('JPY 1,200'),
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
                        SnackBar(content: Text(l10n.paywallRestoreSuccess)),
                      );
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.paywallRestoreFailed(e.toString())),
                      ),
                    );
                  }
                },
                child: Text(l10n.restorePurchases),
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
    final style = isHeader
        ? const TextStyle(fontWeight: FontWeight.bold)
        : const TextStyle();
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 36),
            gap12,
            Text(
              l10n.paywallGenericError(message),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
