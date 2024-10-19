import 'dart:convert';

enum EventStatus {
  connected,
  initialize,
  send_data,
  response,
  close;

  static EventStatus fromMap(String value) => EventStatus.values.firstWhere((e) => e.name == value);
}

class EventConnected {
  final String hash;
  EventConnected({
    required this.hash,
  });

  Map<String, dynamic> toMap() {
    return {
      'event_status': 'connected',
      'hash': hash,
    };
  }

  factory EventConnected.fromMap(Map<String, dynamic> map) {
    return EventConnected(
      hash: map['hash'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventConnected.fromJson(String source) => EventConnected.fromMap(json.decode(source));
}

class EventInitialize {
  final String id;
  final String hash;
  EventInitialize({
    required this.id,
    required this.hash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hash': hash,
    };
  }

  factory EventInitialize.fromMap(Map<String, dynamic> map) {
    return EventInitialize(
      id: map['id'] ?? '',
      hash: map['hash'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventInitialize.fromJson(String source) => EventInitialize.fromMap(json.decode(source));
}

class EventSendData {
  final String id;

  final Map data;
  EventSendData({
    required this.id,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
    };
  }

  factory EventSendData.fromMap(Map<String, dynamic> map) {
    return EventSendData(
      id: map['id'] ?? '',
      data: Map.from(map['data'] ?? const {}),
    );
  }

  String toJson() => json.encode(toMap());

  String buildData() => json.encode(data);

  factory EventSendData.fromJson(String source) => EventSendData.fromMap(json.decode(source));
}
