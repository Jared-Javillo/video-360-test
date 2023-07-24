import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_360_test/main.dart';
import 'package:video_360_test/video_360_page.dart';


void main() {
  group('video_360_page.dart', ()
  {
    test('should return URL when getInitialLink() is not null', () async {
      const mockUrl = 'video_360://example.com?video=github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true';

      const page = Video360Page(initialLink: mockUrl);
      expect(page.initialLink, equals(mockUrl));

      Video360PageState pageState = Video360PageState();
      expect(pageState.extractVideoUrl(mockUrl), equals('github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true'));

      //expect(pageState.toggleBoolean(boolean: boolean));
    });

  });
}

