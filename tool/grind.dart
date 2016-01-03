import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:git/git.dart';

void main(List<String> args) {
  grind(args);
}

@DefaultTask()
@Depends(analyze, format, testTravis, coverage, updateDemo)
void prePush() {}

@Task()
@Depends(analyze, testFormat, test)
void travis() {}

@Task()
void analyze() {
  Analyzer.analyze(existingSourceDirs);
}

@Task()
void test() {
  final platforms = ['firefox', 'chrome', 'dartium', 'safari', 'content-shell'];
  new TestRunner().test(platformSelector: platforms);
}

@Task()
void testTravis() {
  // travis only supports firefox and content-shell it seems
  final platforms = ['firefox', 'content-shell'];
  new TestRunner().test(platformSelector: platforms);
}

@Task('Apply dartfmt to all Dart source files')
void format() {
  DartFmt.format(existingSourceDirs);
}

@Task('Test dartfmt for all Dart source files')
void testFormat() {
  if (DartFmt.dryRun(existingSourceDirs)) {
    throw "dartfmt failure";
  }
}

@Task('Gather and send coverage data')
void coverage() {
  // coveralls doesn't seem to work for html tests
  if (Platform.environment['COVERALLS_TOKEN'] != null) {
    // report to coveralls
    Pub.global.activate('dart_coveralls');
    run('dart_coveralls', arguments: [
      'report',
      '--retry',
      '2',
      '--exclude-test-files',
      'test/test_all.dart'
    ]);
  } else {
    // run coverage locally
    Pub.global.run('dart_dev', arguments: ['coverage']);
  }
}

@Task()
updateDemo() async {
  // disable for now, see https://github.com/dart-lang/pub/issues/1376
  // Pub.global.run('peanut', arguments: ['--directory', 'example']);
  // await runGit(['push', 'origin', 'gh-pages']);
}
