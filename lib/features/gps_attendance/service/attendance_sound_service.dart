import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AttendanceSoundService {

  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAttendanceAlert() async {

    try {

      await _player.play(
        AssetSource(
          'audio/attendance_alert.wav',
        ),
      );

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          duration: 800,
        );
      }

    } catch (_) {}
  }
}