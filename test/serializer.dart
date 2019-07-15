library serializers;

import 'package:built_value/json_object.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'fake_report_content_model.dart';
import 'user_modal.dart';

part 'serializer.g.dart';

@SerializersFor([
  UserModal,
  Geo,
  Address,
  Company,
  FakeReportContentModel,
  FakeReportContentItemModel,
])
final Serializers serializers = _$serializers;
