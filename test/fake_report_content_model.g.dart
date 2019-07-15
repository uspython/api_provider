// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_report_content_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FakeReportContentModel> _$fakeReportContentModelSerializer =
    new _$FakeReportContentModelSerializer();
Serializer<FakeReportContentItemModel> _$fakeReportContentItemModelSerializer =
    new _$FakeReportContentItemModelSerializer();

class _$FakeReportContentModelSerializer
    implements StructuredSerializer<FakeReportContentModel> {
  @override
  final Iterable<Type> types = const [
    FakeReportContentModel,
    _$FakeReportContentModel
  ];
  @override
  final String wireName = 'FakeReportContentModel';

  @override
  Iterable serialize(Serializers serializers, FakeReportContentModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'bills',
      serializers.serialize(object.bills,
          specifiedType: const FullType(
              BuiltList, const [const FullType(FakeReportContentItemModel)])),
    ];

    return result;
  }

  @override
  FakeReportContentModel deserialize(
      Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FakeReportContentModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'bills':
          result.bills.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(FakeReportContentItemModel)
              ])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$FakeReportContentItemModelSerializer
    implements StructuredSerializer<FakeReportContentItemModel> {
  @override
  final Iterable<Type> types = const [
    FakeReportContentItemModel,
    _$FakeReportContentItemModel
  ];
  @override
  final String wireName = 'FakeReportContentItemModel';

  @override
  Iterable serialize(Serializers serializers, FakeReportContentItemModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'postId',
      serializers.serialize(object.postId, specifiedType: const FullType(int)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'body',
      serializers.serialize(object.body, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  FakeReportContentItemModel deserialize(
      Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FakeReportContentItemModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'postId':
          result.postId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'body':
          result.body = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FakeReportContentModel extends FakeReportContentModel {
  @override
  final BuiltList<FakeReportContentItemModel> bills;

  factory _$FakeReportContentModel(
          [void Function(FakeReportContentModelBuilder) updates]) =>
      (new FakeReportContentModelBuilder()..update(updates)).build();

  _$FakeReportContentModel._({this.bills}) : super._() {
    if (bills == null) {
      throw new BuiltValueNullFieldError('FakeReportContentModel', 'bills');
    }
  }

  @override
  FakeReportContentModel rebuild(
          void Function(FakeReportContentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FakeReportContentModelBuilder toBuilder() =>
      new FakeReportContentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FakeReportContentModel && bills == other.bills;
  }

  @override
  int get hashCode {
    return $jf($jc(0, bills.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FakeReportContentModel')
          ..add('bills', bills))
        .toString();
  }
}

class FakeReportContentModelBuilder
    implements Builder<FakeReportContentModel, FakeReportContentModelBuilder> {
  _$FakeReportContentModel _$v;

  ListBuilder<FakeReportContentItemModel> _bills;
  ListBuilder<FakeReportContentItemModel> get bills =>
      _$this._bills ??= new ListBuilder<FakeReportContentItemModel>();
  set bills(ListBuilder<FakeReportContentItemModel> bills) =>
      _$this._bills = bills;

  FakeReportContentModelBuilder();

  FakeReportContentModelBuilder get _$this {
    if (_$v != null) {
      _bills = _$v.bills?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FakeReportContentModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FakeReportContentModel;
  }

  @override
  void update(void Function(FakeReportContentModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FakeReportContentModel build() {
    _$FakeReportContentModel _$result;
    try {
      _$result = _$v ?? new _$FakeReportContentModel._(bills: bills.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'bills';
        bills.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FakeReportContentModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$FakeReportContentItemModel extends FakeReportContentItemModel {
  @override
  final int postId;
  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String body;

  factory _$FakeReportContentItemModel(
          [void Function(FakeReportContentItemModelBuilder) updates]) =>
      (new FakeReportContentItemModelBuilder()..update(updates)).build()
          as _$FakeReportContentItemModel;

  _$FakeReportContentItemModel._(
      {this.postId, this.id, this.name, this.email, this.body})
      : super._() {
    if (postId == null) {
      throw new BuiltValueNullFieldError(
          'FakeReportContentItemModel', 'postId');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('FakeReportContentItemModel', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('FakeReportContentItemModel', 'name');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('FakeReportContentItemModel', 'email');
    }
    if (body == null) {
      throw new BuiltValueNullFieldError('FakeReportContentItemModel', 'body');
    }
  }

  @override
  FakeReportContentItemModel rebuild(
          void Function(FakeReportContentItemModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$FakeReportContentItemModelBuilder toBuilder() =>
      new _$FakeReportContentItemModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FakeReportContentItemModel &&
        postId == other.postId &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        body == other.body;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, postId.hashCode), id.hashCode), name.hashCode),
            email.hashCode),
        body.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FakeReportContentItemModel')
          ..add('postId', postId)
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('body', body))
        .toString();
  }
}

class _$FakeReportContentItemModelBuilder
    extends FakeReportContentItemModelBuilder {
  _$FakeReportContentItemModel _$v;

  @override
  int get postId {
    _$this;
    return super.postId;
  }

  @override
  set postId(int postId) {
    _$this;
    super.postId = postId;
  }

  @override
  int get id {
    _$this;
    return super.id;
  }

  @override
  set id(int id) {
    _$this;
    super.id = id;
  }

  @override
  String get name {
    _$this;
    return super.name;
  }

  @override
  set name(String name) {
    _$this;
    super.name = name;
  }

  @override
  String get email {
    _$this;
    return super.email;
  }

  @override
  set email(String email) {
    _$this;
    super.email = email;
  }

  @override
  String get body {
    _$this;
    return super.body;
  }

  @override
  set body(String body) {
    _$this;
    super.body = body;
  }

  _$FakeReportContentItemModelBuilder() : super._();

  FakeReportContentItemModelBuilder get _$this {
    if (_$v != null) {
      super.postId = _$v.postId;
      super.id = _$v.id;
      super.name = _$v.name;
      super.email = _$v.email;
      super.body = _$v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FakeReportContentItemModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FakeReportContentItemModel;
  }

  @override
  void update(void Function(FakeReportContentItemModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FakeReportContentItemModel build() {
    final _$result = _$v ??
        new _$FakeReportContentItemModel._(
            postId: postId, id: id, name: name, email: email, body: body);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
