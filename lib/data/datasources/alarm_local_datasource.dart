import 'package:hive/hive.dart';
import '../models/alarm_model.dart';

abstract class AlarmLocalDataSource {
  Future<List<AlarmModel>> getAlarms();
  Future<void> saveAlarm(AlarmModel alarm);
  Future<void> deleteAlarm(String id);
  Future<void> toggleAlarm(String id);
}

class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  final Box _box;

  AlarmLocalDataSourceImpl(this._box);

  @override
  Future<List<AlarmModel>> getAlarms() async {
    final alarms = <AlarmModel>[];
    for (var key in _box.keys) {
      final raw = _box.get(key);
      if (raw != null) {
        final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(raw as Map);
        alarms.add(AlarmModel.fromJson(jsonMap));
      }
    }
    // Sort by hour and minute ascending
    alarms.sort((a, b) {
      if (a.hour != b.hour) return a.hour.compareTo(b.hour);
      return a.minute.compareTo(b.minute);
    });
    return alarms;
  }

  @override
  Future<void> saveAlarm(AlarmModel alarm) async {
    await _box.put(alarm.id, alarm.toJson());
  }

  @override
  Future<void> deleteAlarm(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> toggleAlarm(String id) async {
    final raw = _box.get(id);
    if (raw != null) {
      final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(raw as Map);
      final model = AlarmModel.fromJson(jsonMap);
      final updated = AlarmModel.fromEntity(model.copyWith(enabled: !model.enabled));
      await _box.put(id, updated.toJson());
    }
  }
}
