h3. flutter


h4. flutter widget
참고 사이트 : https://jaceshim.github.io/2019/01/24/flutter-study-widgets/
- flutter의 구성 요소들은 모두 위젯
```
class [클래스 이름] extends StatelessWidget { --> StatelessWidget 또는 StatefulWidgets 클래스를 확장
	Widget build(context) {    --> build 메소드를 반드시 포함해야 함. 다른 위젯으로 리턴하는 함수.
		return new Text('text');  --> 다른 위젯에게 text값을 전달함
	}
}

다른 곳에서 [클래스 이름] 함수를 사용하고 싶을 때
child: new [클래스 이름]('This string would render and be big')
```

h4. Stateless and StatefulWidgets
- 플러터 위젯은 확장이 필요한데 대부분 Stateless and StatefulWidgets
- 차이점? 위젯 내에 상태(state) 개념이 있어서 상태가 변경되면 다시 렌더링하는 메소드가 클래스에 있음
- stateless widget : stateless widget의 부모 위젯으로부터 argument를 받음. argument는 final 멤버 변수에 저장됨.
위젯이 build를 하게 되면 저장한 변수를 사용해 새로 생성되는 위젯의 새 인수를 파생 시킴(?)

- 입력을 받아서 다양한 일을 처리하게 하려면 상태 값을 전달해야 함.
-> 그 상태를 flutter는 StatefulWidget을 이용해 전달함.
- StatefulWidget은 어떻게 State 오브젝트를 생성하는지 알고 그게 state를 유지하는 데 사용되는 것을 아는 특별한 위젯임.
```
ex)

class Counter extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this case nothing) provided by the parent and used by the build
  // method of the State. Fields in a Widget subclass are always marked "final".
  // 이 클래스는 state를 설정함. 어떤 변수(여기선 사용하지 않았음)를 부모로부터 받아서 가지고 있고 State의 빌드함수 실행 시에 사용됨.
  // 위젯의 subclass에 있는 필드는 항상 final을 가져야 함.

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      // This call to setState tells the Flutter framework that
      // something has changed in this State, which causes it to rerun
      // the build method below so that the display can reflect the
      // updated values. If we changed _counter without calling
      // setState(), then the build method would not be called again,
      // and so nothing would appear to happen.
	  // setState()를 부르는 것은 Flutter framework에게 이 State에서 뭔가 바뀌었다고 알려줌. 이것은 아래의 build 메소드를 재실행하게 해서 display에 변경된 값을 보여주도록 한다.
	  // 만약 _counter 변수를 setState() 콜 없이 변경한다면 build 메소드는 변경되지 않고 화면에 아무런 일도 일어나지 않는다.
	  // 변경될 내용을 setState에 꼭 쓰라 이 말이군!
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _increment method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
	// build 메소드는 setState가 콜 될때마다 재실행됨. 예를 들어 위의 _increment 메소드가 실행 끝날 때 재실행됨.
	// Flutter framework는 build 메소드를 빠르게 재실행하도록 최적화하고 있어서 위젯의 인스턴스를 개별적으로 변경하는 것보다 update가 필요한 모든 것을 그냥 재빌드 할 수 있음
    return Row(
      children: <Widget>[
        RaisedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
        Text('Count: $_counter'),
      ],
    );
  }
}
```
- 왜 StatefulWidget과 State를 분리했는지 궁금할 것.
- flutter에서는 이 두 오브젝트가 다른 life cycle을 가짐.
- Stateful위젯은 임시 오브젝트로 현재 상태에서 앱의 표현을 구성하는데 사용됨.
- State객체는 반대로 build()가 콜 되는 사이에도 영구적이어서 정보를 기억할 수 있다
- 위의 예제는 사용자의 입력을 받고 내부 build 메소드에서 바로 결과를 사용함.
- 복잡한 앱에서는 한 위젯은 날짜 또는 위치와 같은 특정 정보를 모으는 목표로 복잡한 사용자 인터페이스를 제공 할 수 있지만 다른 위젯은 해당 정보를 사용하여 전체 프레젠테이션을 변경할 수 있습니다.
- flutter에서는 변경 알림이 콜백의 방법으로 위젯 구조로 올라간다. 현재 상태는 표현하기 위해 stateless 위젯으로 흘러간다. 이 흐름을 redirect하는 곳으로 일반적인 부모는 State임.

```
class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  CounterIncrementor({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      CounterIncrementor(onPressed: _increment),
      CounterDisplay(count: _counter),
    ]);
  }
}
```
- Counter : StatefulWidget
- _CounterState : State -> build()에서 대기하고 있다가  onPressed 일 때 _increment를 실행시키고 setState가 실행되니 다시 build 실행됨. CounterIncrementor와 CounterDisplay가 다시 실행됨.
- lifecycle 참고
--https://flutterbyexample.com/stateful-widget-lifecycle/
-- https://stackoverflow.com/questions/41479255/life-cycle-in-flutter
