import 'dart:html';

import 'package:angular2/angular2.dart';

@Directive(selector: 'textarea[autogrow]')
class AutogrowDirective implements AfterViewInit {
  final ElementRef _ref;

  AutogrowDirective(this._ref);

  // Box sizing style property is set to border-box, to make behaviour
  // consistent with different css resets etc.
  @HostBinding('style.box-sizing') get boxSizing => 'border-box';

  // Only allow horizontal resize, as vertical resize is done automatically.
  @HostBinding('style.resize') get resize => 'horizontal';

  TextAreaElement get textArea => _ref.nativeElement;

  ngAfterViewInit() {
    // resize the height when the textarea is initialized
    resizeHeight();
  }

  /// Resize the height of the textarea to match the current content.
  /// This method is automatically triggered with new input. You can also
  /// trigger this method with a custom event, e.g.:
  ///
  ///         textarea.dispatchEvent(new CustomEvent('input'));
  ///
  @HostListener('input')
  void resizeHeight() {
    // shrinks the textarea when needed
    textArea.style.height = 'auto';

    // calculates the border top width + border bottom width
    final borderCorrection = textArea.offsetHeight - textArea.clientHeight;

    // let the height match the scrollHeight + a border correcion added
    // note that this will work only because we force the textarea to have
    // box-sizing: border-box
    textArea.style.height = '${textArea.scrollHeight + borderCorrection}px';
  }
}
