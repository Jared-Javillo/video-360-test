import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_360_test/main.dart';


void main() {
  group('main.dart', ()
  {
    test('should return URL when getInitialLink() is not null', () async {
      const mockUrl = 'video_360://example.com?video=github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true';

      Future<String?> mockGetInitialLink() async {
        return mockUrl;
      }


      final result = await handleInitialLink(getLinkMethod: mockGetInitialLink());
      print(result);
      expect(result, equals(mockUrl));
    });
    test('should return URL when getInitialLink() is not null', () async {
      const mockUrl = 'video_360://example.com?video=github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true';

      Future<String?> mockGetInitialLink() async {
        return mockUrl;
      }

      WidgetsFlutterBinding.ensureInitialized();
      final result = await handleInitialLink(getLinkMethod: mockGetInitialLink());
      print(result);
      expect(result, equals(mockUrl));
    });
  });
}

