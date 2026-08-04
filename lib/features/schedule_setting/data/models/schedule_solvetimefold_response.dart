import 'package:bluebits_app/features/schedule_setting/data/models/confllict_response_model.dart';

class ScheduleSolvetimefoldResponse {
  final String? id;
  final String? semesterId;
  final List<ConflictItem>? conflicts;

  ScheduleSolvetimefoldResponse({this.id, this.semesterId, this.conflicts});

  factory ScheduleSolvetimefoldResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleSolvetimefoldResponse(
      id: json['_id'] as String?,
      semesterId: json['semesterId'] as String?,
      conflicts: json['conflicts'] != null
          ? (json['conflicts'] as List)
                .map((e) => ConflictItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'semesterId': semesterId,
      'conflicts': conflicts?.map((e) => e.toJson()).toList(),
    };
  }
}
