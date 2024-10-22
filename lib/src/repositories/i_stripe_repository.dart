abstract interface class IStripeRepository {
  /// DOCS: https://docs.stripe.com/api/checkout/sessions/create?lang=curl
  Future<String> checkoutCreateSession({
    required String description,
    required double amount,
    required String country,
    required String successUrl,
    required String cancelUrl,
    String? paymentIntentTransferGroup,
  });
  Future<String> createAccount();
  Future<String> createAccountLink({required String accountId, required String country});
}

class StripeFactoryCountry {
  final String baseUrlApp;
  final String baseUrlPortal;
  final String currency;
  StripeFactoryCountry({
    required this.baseUrlApp,
    required this.baseUrlPortal,
    required this.currency,
  });
  static Map<String, StripeFactoryCountry> countries = {
    'br': StripeFactoryCountry(baseUrlApp: 'https://paipfood.com', baseUrlPortal: 'https://portal.paipfood.com', currency: 'BRL'),
    'uk': StripeFactoryCountry(baseUrlApp: 'https://paipfood.co.uk', baseUrlPortal: 'https://portal.paipfood.co.uk', currency: 'LBR'),
    'pt': StripeFactoryCountry(baseUrlApp: 'https://pt.paipfood.com', baseUrlPortal: 'https://pt.portal.paipfood.com', currency: 'EUR'),
  };

  static StripeFactoryCountry fromCountry(String country) {
    final result = countries[country.toLowerCase().trim()];
    if (result == null) throw Exception('Country not found');
    return result;
  }
}

extension StripeAmountExtension on num {
  int toStripeAmount() {
    return (this * 100).toInt();
  }
}
