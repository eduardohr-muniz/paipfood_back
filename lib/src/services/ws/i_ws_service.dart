import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import 'events.dart';

abstract class IWsService {
  Map<String, WebSocketChannel> channels = {};
  Map<String, String> hashCodechannels = {};

  Future<Response> onRequest(RequestContext context, {Function(Map<String, dynamic> event)? onEvent}) async {
    final handler = webSocketHandler(
      (channel, protocol) {
        channels[channel.hashCode.toString()] = channel;
        final connected = EventConnected(hash: channel.hashCode.toString());
        channel.sink.add(connected.toJson());

        channel.stream.listen(
          (event) {
            if (event is String) {
              try {
                final decode = json.decode(event) as Map<String, dynamic>;
                final eventStatus = EventStatus.fromMap(decode['event_status']);

                if (eventStatus == EventStatus.initialize) {
                  final eventInitialize = EventInitialize.fromMap(decode);
                  onInitialize(hashcode: eventInitialize.hash, id: eventInitialize.id);
                  channel.sink.add('Success save id: ${eventInitialize.id}');
                  return;
                }
                if (eventStatus == EventStatus.send_data) {
                  final eventSendData = EventSendData.fromMap(decode);
                  final channel = channels[eventSendData.id];
                  if (channel != null) channel.sink.add(eventSendData.buildData());
                }

                onEvent?.call(decode);
              } catch (e) {
                log('Error decoding event: $e', name: 'ws_error');
                channel.sink.add('Error processing event');
              }
            } else {
              log(
                'Invalid event type received: ${event.runtimeType}',
                name: 'ws_error',
              );
            }
          },
          onDone: () {
            channels.remove(channel.hashCode.toString());
            log('Client disconnected: ${channel.hashCode}', name: 'ws_disconnection');
          },
          onError: (error) {
            log(error.toString(), name: 'ws_error');

            final id = hashCodechannels[channel.hashCode.toString()];
            if (id != null) {
              channels.remove(id);
              hashCodechannels.remove(channel.hashCode.toString());
              log('Removed channel due to error: $id', name: 'ws_error');
            }
          },
        );
      },
    );

    return handler(context);
  }

  void onInitialize({required String hashcode, required String id}) {
    final channel = channels[hashcode];
    if (channel != null) {
      channels
        ..remove(hashcode)
        ..addAll({id: channel});

      hashCodechannels[hashcode] = id;
      log('Channel initialized with new id: $id', name: 'ws_initialize');
    } else {
      log('Failed to initialize: channel not found for hashcode $hashcode', name: 'ws_error');
    }
  }
}
