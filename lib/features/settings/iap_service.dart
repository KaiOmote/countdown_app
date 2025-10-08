// lib/features/settings/iap_service.dart
import 'package:flutter/services.dart';                    // 👈 for PlatformException
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const kEntitlementPro = 'pro';
const kProductIdPro = 'pro_lifetime_jp_1200';

/// Riverpod provider exposing whether user owns Pro entitlement.
final isProProvider = FutureProvider<bool>((ref) async {
  try {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(kEntitlementPro);
  } catch (_) {
    return false;
  }
});

class IAPService {
  static Future<void> init() async {
    await Purchases.configure(
      PurchasesConfiguration('public_sdk_key_from_revenuecat'), // TODO replace
    );
  }

  /// Start a one-time lifetime purchase.
  static Future<bool> purchasePro() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.lifetime;
      if (package == null) return false;

      // ✅ new API uses purchasePackage(package.identifier)
      final result = await Purchases.purchasePackage(package);

      // ✅ purchasePackage now returns a CustomerInfo
      final info = result.customerInfo;
      return info.entitlements.active.containsKey(kEntitlementPro);
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  /// Restore prior purchases.
  static Future<void> restore() async {
    await Purchases.restorePurchases();
  }
}
