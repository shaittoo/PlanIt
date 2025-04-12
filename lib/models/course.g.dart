// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 1;

  @override
  Course read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Course(
      id: fields[0] as String?,
      name: fields[1] as String,
      type: fields[2] as String,
      startTime: fields[3] as TimeOfDay,
      endTime: fields[4] as TimeOfDay,
      weekDays: (fields[5] as List).cast<String>(),
      location: fields[6] as String,
      instructor: fields[7] as String,
      color: fields[8] as Color,
      scheduleId: fields[9] as String,
      tag: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.weekDays)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.instructor)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.scheduleId)
      ..writeByte(10)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
