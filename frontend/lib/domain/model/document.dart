import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dafluta/dafluta.dart';
import 'package:tensionpath/utils/error_handler.dart';

typedef DocumentData = Map<dynamic, dynamic>;

class Document {
  final String docId;
  final DocumentData _data;

  const Document._(this.docId, this._data);

  List<String> get fieldNames => _data.keys.map((e) => e.toString()).toList();

  DocumentData get data => _data;

  factory Document.load(DocumentSnapshot doc) {
    final dynamic data = doc.data();

    if (data != null) {
      return Document._(
        doc.id,
        data as DocumentData,
      );
    } else {
      return Document._(doc.id, {});
    }
  }

  factory Document.fromJsonObject(JsonObject data) => Document._(
      data.has('firestoreId') ? data.getString('firestoreId')! : '', data);

  static List<Document> fromJsonList(JsonArray json) =>
      json.map(Document.fromJsonObject).toList();

  factory Document.fromMap(String id, DocumentData map) => Document._(id, map);

  Type _type(String field) => _get<dynamic>(field, null).runtimeType;

  String? getString(String field, [String? defaultValue]) =>
      _get<String>(field, defaultValue);

  List<String> getStringList(String field) {
    final List<dynamic>? list = _get<List<dynamic>>(field, []);

    return list?.map((e) => e as String).toList() ?? [];
  }

  List<Document> getList(String field) {
    final List<dynamic>? list = _get<List<dynamic>>(field, []);
    final List<Document> documents = [];

    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        final dynamic entry = list[i];
        documents.add(Document.fromMap('$i', entry as DocumentData));
      }
    }

    return documents;
  }

  double? getDouble(String field, [double? defaultValue]) =>
      _get<double>(field, defaultValue);

  num? getNumber(String field, [num? defaultValue]) =>
      _get<num>(field, defaultValue);

  bool? getBool(String field, [bool? defaultValue]) =>
      _get<bool>(field, defaultValue);

  Document getDocument(String field, [bool splitField = true]) =>
      Document.fromMap(
        field,
        _get<DocumentData>(field, {}, splitField) ?? {},
      );

  Timestamp? getTimestamp(String field, [Timestamp? defaultValue]) =>
      _get<Timestamp>(field, defaultValue);

  DateTime? getDateTime(String field, [DateTime? defaultValue]) {
    final Type type = _type(field);

    if (type == Timestamp) {
      final Timestamp? value = getTimestamp(field, null);

      return (value != null)
          ? DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch)
          : defaultValue;
    } else if (type == String) {
      final String? value = getString(field, null);

      return (value != null) ? DateTime.parse(value).toLocal() : defaultValue;
    } else {
      return defaultValue;
    }
  }

  E? getEnum<E extends Enum, V>({
    required String field,
    required List<E> list,
    required V Function(E) mapper,
    E? defaultValue,
  }) {
    final dynamic value = _get<dynamic>(field, null);

    return Enums.parse(
      value: value,
      list: list,
      mapper: mapper,
      defaultValue: defaultValue,
    );
  }

  bool contains(String field, [bool splitField = true]) {
    try {
      final List<String> fields = splitField ? field.split('.') : [field];
      bool result = true;
      dynamic currentData = _data;

      for (final String fieldName in fields) {
        final List<dynamic> fieldsList =
            currentData.keys.map((e) => e.toString()).toList();

        if (fieldsList.contains(fieldName)) {
          currentData = currentData[fieldName];
        } else {
          result = false;
          break;
        }
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  T? _get<T>(String field, T? defaultValue, [bool splitField = true]) {
    try {
      if (contains(field, splitField)) {
        final List<String> fields = splitField ? field.split('.') : [field];
        dynamic result = _data;

        for (final String fieldName in fields) {
          result = result[fieldName];
        }

        return (result != null) ? (result as T) : defaultValue;
      } else {
        return defaultValue;
      }
    } catch (e) {
      ErrorHandler.process(
        Exception('${e.toString()}. Field: $field. Document ID: $docId'),
      );

      return defaultValue;
    }
  }
}
