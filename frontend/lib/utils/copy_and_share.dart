import 'package:share_plus/share_plus.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/services/clipboard_text.dart';
import 'package:undervoltage/services/platform.dart';

class CopyAndShare {
  static void match(String matchId) {
    final String link = '${Constants.MATCH_URL}$matchId';

    _copyToClipboard(link);

    if (Platform.isMobile) {
      _onShare(link);
    }
  }

  static void _copyToClipboard(String link) => ClipboardText().copy(link);

  static void _onShare(String link) {
    try {
      Share.share(
        link,
        subject: 'Join the match!',
      );
    } catch (e) {
      // ignore
    }
  }
}
