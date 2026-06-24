import '../../core/model/shift_model.dart';

class  ActiveShiftManager {
  ShiftModel? _shift;

  /// Set employer-assigned active shift
  void set(ShiftModel shift) {
    _shift = shift;
  }

  /// Get current active shift for GPS + attendance flow
  ShiftModel? get current => _shift;

  /// Check if shift is available
  bool get hasShift => _shift != null;

  /// Clear shift (optional: logout / duty end)
  void clear() {
    _shift = null;
  }
}