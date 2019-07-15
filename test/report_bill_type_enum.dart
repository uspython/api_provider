/*
 * CityHome App
 * @Author: jeffzhao
 * @Date: 2019-05-29 15:17:56
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-05-29 15:55:38
 * Copyright  © 2019 Beijing Qingsu Innovation Co. Ltd. All rights reserved.
 */

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'report_bill_type_enum.g.dart';

class ReportBillTypeEnum extends EnumClass {
  static const ReportBillTypeEnum pending = _$pending;
  static const ReportBillTypeEnum confirmed = _$confirmed;
  static const ReportBillTypeEnum balanced = _$balanced;

  const ReportBillTypeEnum._(String name) : super(name);

  static BuiltSet<ReportBillTypeEnum> get values => _$vls;
  static ReportBillTypeEnum valueOf(String name) => _$vlOf(name);

  static String typeName(String enumName) {
    final type = ReportBillTypeEnum.valueOf(enumName);
    switch (type) {
      case ReportBillTypeEnum.pending:
        return '待确认';
      case ReportBillTypeEnum.confirmed:
        return '已确认';
      case ReportBillTypeEnum.balanced:
        return '已结算';
      default:
        return 'unknown';
    }
  }
}
