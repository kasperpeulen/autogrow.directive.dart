import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'package:ng2_autogrow_textarea/ng2_autogrow_textarea.dart';

void main() {
  bootstrap(AppComponent);
}

@Component(
    selector: 'my-app',
    directives: const [AutogrowDirective],
    template: '''
    <textarea [autogrow]
              placeholder="Try typing something..."></textarea>
    ''')
class AppComponent {}
