import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart';
import 'package:paipfood_back/src/repositories/I_stripe_repository.dart';
import 'package:paipfood_back/src/repositories/stripe_repository.dart';
import 'package:paipfood_back/src/services/authenticator.dart';
import 'package:paipfood_back/src/services/client/clien_exports.dart';

Authenticator? _authenticator;
Middleware authenticatorProvider() => provider<Authenticator>((context) => _authenticator ??= Authenticator());

IClient? _client;
Middleware dio() => provider<IClient>((context) => _client ??= ClientDio());

IClient? _clientStripe;
Middleware dioStripe() => provider<IClient>((context) => _clientStripe ??= ClientDio(baseOptions: BaseOptions(baseUrl: 'https://api.stripe.com')));

IStripeRepository? _stripeRepository;
Middleware stripeRepository() => provider<IStripeRepository>((context) => _stripeRepository ??= StripeRepository(client: context.read<IClient>()));
