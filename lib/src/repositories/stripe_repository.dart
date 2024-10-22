import 'package:paipfood_back/src/repositories/I_stripe_repository.dart';
import 'package:paipfood_back/src/services/client/i_client.dart';

class StripeRepository implements IStripeRepository {
  final IClient client;

  StripeRepository({required this.client});

  @override
  Future<String> checkoutCreateSession(
      {required String description,
      required double amount,
      required String country,
      required String successUrl,
      required String cancelUrl,
      String? paymentIntentTransferGroup}) async {
    final stripe = StripeFactoryCountry.fromCountry(country);

    final Map<String, dynamic> data = {
      'success_url': successUrl,
      'cancel_url': cancelUrl,
      'line_items[0][price_data][currency]': stripe.currency,
      'line_items[0][price_data][product_data][name]': description,
      'line_items[0][price_data][unit_amount]': amount.toStripeAmount().toString(),
      'line_items[0][quantity]': '1',
      'mode': 'payment',
    };

    if (paymentIntentTransferGroup != null) {
      data['payment_intent_data[transfer_group]'] = paymentIntentTransferGroup;
    }

    final request = await client.post(
      '/v1/checkout/sessions',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer sk_test_51PpA0h02tlOh1TZaQUlL9PbNeBCZUzvaOpmffDT2l2ELPCveY7gcq9ZDW0E99agH5ve9pn15ZnVmwS9xsI9BQKmZ0097ZGknJW',
      },
      data: data,
    );

    return request.data['url'];
  }

  @override
  Future<String> createAccount() async {
    final request = await client.post('/v1/checkout/sessions', headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer sk_test_51PpA0h02tlOh1TZaQUlL9PbNeBCZUzvaOpmffDT2l2ELPCveY7gcq9ZDW0E99agH5ve9pn15ZnVmwS9xsI9BQKmZ0097ZGknJW',
    }, data: {
      'type': 'express',
    });

    return request.data['id'];
  }

  @override
  Future<String> createAccountLink({required String accountId, required String country}) async {
    final stripe = StripeFactoryCountry.fromCountry(country);
    final request = await client.post('/v1/checkout/sessions', headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer sk_test_51PpA0h02tlOh1TZaQUlL9PbNeBCZUzvaOpmffDT2l2ELPCveY7gcq9ZDW0E99agH5ve9pn15ZnVmwS9xsI9BQKmZ0097ZGknJW',
    }, data: {
      'return_url': '${stripe.baseUrlPortal}/account/return_url',
      'refresh_url': '${stripe.baseUrlPortal}/account/refresh_url',
      'account': accountId,
      'type': 'account_onboarding'
    });

    return request.data['url'];
  }
}
