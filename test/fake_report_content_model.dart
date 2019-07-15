/*
 * CityHome App
 * @Author: jeffzhao
 * @Date: 2019-05-29 15:56:46
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-05-29 17:58:30
 * Copyright  © 2019 Beijing Qingsu Innovation Co. Ltd. All rights reserved.
 */

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'report_bill_type_enum.dart';

part 'fake_report_content_model.g.dart';

abstract class FakeReportContentModel
    implements Built<FakeReportContentModel, FakeReportContentModelBuilder> {
  FakeReportContentModel._();

  factory FakeReportContentModel([updates(FakeReportContentModelBuilder b)]) =
      _$FakeReportContentModel;

  double get numbers => 999999.13;
  String get dateString => '2019-12-13';
  ReportBillTypeEnum get billType => ReportBillTypeEnum.pending;
  BuiltList<FakeReportContentItemModel> get bills;

  static Serializer<FakeReportContentModel> get serializer =>
      _$fakeReportContentModelSerializer;
}

abstract class FakeReportContentItemModel
    implements
        Built<FakeReportContentItemModel, FakeReportContentItemModelBuilder> {
  FakeReportContentItemModel._();

  factory FakeReportContentItemModel(
          [updates(FakeReportContentItemModelBuilder b)]) =
      _$FakeReportContentItemModel;

  @BuiltValueField(wireName: 'postId')
  int get postId;
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'email')
  String get email;
  @BuiltValueField(wireName: 'body')
  String get body;

  static Serializer<FakeReportContentItemModel> get serializer =>
      _$fakeReportContentItemModelSerializer;
}

abstract class FakeReportContentItemModelBuilder
    implements
        Builder<FakeReportContentItemModel, FakeReportContentItemModelBuilder> {
  int postId = 0x008;
  int id = 0;
  String name = 'hello world';
  String email = 'email@email.com';
  String body = 'this is body';

  factory FakeReportContentItemModelBuilder() =
      _$FakeReportContentItemModelBuilder;
  FakeReportContentItemModelBuilder._();
}
