// Because Angular is using dart:html, we need these tests to run on an actual
// browser. This means that it should be run with `-p dartium` or `-p chrome`.
@TestOn('browser')
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_testing/angular2_testing.dart';
import 'package:test/test.dart';
import 'package:ng2_autogrow_textarea/ng2_autogrow_textarea.dart';

@Component(
    selector: 'test-cmp',
    directives: const [AutogrowDirective],
    template: '<textarea [autogrow]>\n\n</textarea>')
class TestComponent {}

void main() {
  initAngularTests();

  ngTest('it has box-sizing: border-box', (TestComponentBuilder tcb) async {
    final rootTC = await tcb.createAsync(TestComponent);
    final textarea = getTextarea(rootTC);
    rootTC.detectChanges();

    expect(textarea.getComputedStyle().boxSizing, equals('border-box'));
  });

  ngTest('it grows when pressing enter', (TestComponentBuilder tcb) async {
    final rootTC = await tcb.createAsync(TestComponent);
    final textarea = getTextarea(rootTC);

    rootTC.detectChanges();

    final before = inPixels(textarea.getComputedStyle().height);

    textarea.value = '\n' * 3;
    textarea.dispatchEvent(new CustomEvent('input'));
    rootTC.detectChanges();

    final after = inPixels(textarea.getComputedStyle().height);

    expect(after, greaterThan(before));
  });

  ngTest('it can shrink back after growing', (TestComponentBuilder tcb) async {
    final rootTC = await tcb.createAsync(TestComponent);
    final textarea = getTextarea(rootTC);

    textarea.value = '\n' * 3;
    textarea.dispatchEvent(new CustomEvent('input'));
    rootTC.detectChanges();

    final before = inPixels(textarea.getComputedStyle().height);

    textarea.value = '\n' * 2;
    textarea.dispatchEvent(new CustomEvent('input'));
    rootTC.detectChanges();

    final after = inPixels(textarea.getComputedStyle().height);

    expect(after, lessThan(before));
  });

  ngTest('it eliminates any vertical overflow',
      (TestComponentBuilder tcb) async {
    final rootTC = await tcb.createAsync(TestComponent);
    final textarea = getTextarea(rootTC);

    textarea.value = '\n' * 100;
    textarea.dispatchEvent(new CustomEvent('input'));
    rootTC.detectChanges();

    textarea.scrollTop = 1;
    rootTC.detectChanges();

    expect(textarea.scrollTop, equals(0));
  });
}

TextAreaElement getTextarea(ComponentFixture rootTC) {
  return rootTC.debugElement.nativeElement.querySelector('textarea');
}

int inPixels(String styleString) {
  return int.parse(styleString.replaceAll('px', ''));
}
