import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:paipfood_back/src/repositories/I_stripe_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final stripe = context.read<IStripeRepository>();
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context, stripe),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context, IStripeRepository stripe) async {
  BuildLinkWebCheckoutBody body;
  try {
    body = BuildLinkWebCheckoutBody.fromMap(await context.request.json() as Map<String, dynamic>);
  } catch (e) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Invalid body. \ne.g: \n ${BuildLinkWebCheckoutBody.buildExampleBody()}');
  }

  final link = await stripe.checkoutCreateSession(
    description: body.description,
    amount: body.amount,
    country: body.country,
    successUrl: body.successUrl,
    cancelUrl: body.cancelUrl,
    paymentIntentTransferGroup: body.paymentIntentTransferGroup,
  );

  return Response.json(body: {'link': link});
}

class BuildLinkWebCheckoutBody {
  final String description;
  final double amount;
  final String country;
  final String orderId;
  final String successUrl;
  final String cancelUrl;
  final String? paymentIntentTransferGroup;

  BuildLinkWebCheckoutBody({
    required this.description,
    required this.amount,
    required this.country,
    required this.orderId,
    required this.successUrl,
    required this.cancelUrl,
    this.paymentIntentTransferGroup,
  });

  static String buildExampleBody() {
    return jsonEncode({
      'description': 'Order 1',
      'amount': 20.50,
      'country': 'br',
      'order_id': 'abcd-1234',
      'success_url': 'https://example.com/success',
      'cancel_url': 'https://example.com/cancel',
      'payment_intent_transfer_group': 'abcd-1234',
    });
  }

  factory BuildLinkWebCheckoutBody.fromMap(Map<String, dynamic> map) {
    return BuildLinkWebCheckoutBody(
      description: map['description'],
      amount: map['amount']?.toDouble(),
      country: map['country'],
      orderId: map['order_id'],
      successUrl: map['success_url'],
      cancelUrl: map['cancel_url'],
      paymentIntentTransferGroup: map['payment_intent_transfer_group'],
    );
  }
}
