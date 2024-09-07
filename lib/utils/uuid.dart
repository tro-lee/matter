import 'package:uuid/uuid.dart';

genUuid() {
  // 创建一个 Uuid 实例
  var uuid = const Uuid();

  // 生成一个新的 UUID
  String newUuid = uuid.v4();

  return newUuid;
}
