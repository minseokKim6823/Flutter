import 'package:drift/drift.dart';
class Schedules extends Table{
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get endTime => integer()();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get startTime => integer()();
}