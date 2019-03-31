
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_modal.g.dart';

abstract class UserModal implements Built<UserModal, UserModalBuilder> {
  factory UserModal([updates(UserModalBuilder b)]) = _$UserModal;
  UserModal._();

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'username')
  String get username;
  @BuiltValueField(wireName: 'email')
  String get email;
  @BuiltValueField(wireName: 'address')
  Address get address;
  @BuiltValueField(wireName: 'phone')
  String get phone;
  @BuiltValueField(wireName: 'website')
  String get website;
  @BuiltValueField(wireName: 'company')
  Company get company;

  static Serializer<UserModal> get serializer => _$userModalSerializer;
}

abstract class Address implements Built<Address, AddressBuilder> {

  factory Address([updates(AddressBuilder b)]) = _$Address;
  Address._();

  @BuiltValueField(wireName: 'street')
  String get street;
  @BuiltValueField(wireName: 'suite')
  String get suite;
  @BuiltValueField(wireName: 'city')
  String get city;
  @BuiltValueField(wireName: 'zipcode')
  String get zipcode;
  @BuiltValueField(wireName: 'geo')
  Geo get geo;

  static Serializer<Address> get serializer => _$addressSerializer;
}

abstract class Geo implements Built<Geo, GeoBuilder> {
  static Serializer<Geo> get serializer => _$geoSerializer;
    String get lat;
    String get lng;

  factory Geo([updates(GeoBuilder b)]) = _$Geo;
  Geo._();
}

abstract class Company implements Built<Company, CompanyBuilder> {

  factory Company([updates(CompanyBuilder b)]) = _$Company;
  Company._();

  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'catchPhrase')
  String get catchPhrase;
  @BuiltValueField(wireName: 'bs')
  String get bs;

  static Serializer<Company> get serializer => _$companySerializer;
}
