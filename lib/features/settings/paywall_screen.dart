import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/gaps.dart';
import '../../widgets/app_button.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB3C7), Color(0xFFCFB7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/paywall_hero.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          gap24,

          // Title
          Center(
            child: Text(
              'Unlock Pro',
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
            label: 'Unlock Pro',
            style: AppButtonStyle.filled,
            onPressed: () {
              // TODO T11: hook into RevenueCat or IAP
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Purchase flow not yet implemented')),
              );
            },
          ),
          gap12,
          Center(
            child: Text(
              'One-time purchase ¥1,200 JPY',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildRow(String feature, String free, String pro, {bool isHeader = false}) {
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
