import 'dart:async';
import 'dart:io'; //표준 입출력

void main() {
  final controller = StreamController();
  final stream = controller.stream;
  Stream<String> calculate(int number) async* {
    yield "입력하세요";
  }
  var myIn;
  calculate(1).listen((val) {
    for (var tmp = 1; tmp < 5; tmp++) {
      print("입력하세요");
      myIn = stdin.readLineSync();
      myIn = int.parse(myIn); //문자열을 숫자로 바꿈
      controller.sink.add(myIn);
      print("i=$myIn");
    }
  });
}
