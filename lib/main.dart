import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Khi chạy flutter run, compiler default vô tìm trong file này, hàm main() là entry để chạy app
void main() {
  // Inflate: load 1 widget vào memory vào draw nó lên màn hình
  runApp(MyApp());
}

// StatelessWidget: dạng widget k có state, có nội dung tĩnh k thay đổi
class MyApp extends StatelessWidget {
  // Constructor, gồm 1 arg là field key kế thừa từ base class (super)
  // Key là 1 field quan trọng của Widget giúp phân biệt giữa chúng
  // Đây là cách viết rút gọn super parameter forwarding
  const MyApp({super.key});

  // Draw widget lên màn hình, với StatelessWidget chỉ build lại khi widget cha build lại hoặc hot reload
  // BuildContext: lưu thông tin về vị trí của widget thời điểm lệnh build đc gọi
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider: widget sub đến 1 obj, khi obj đó thay đổi, widget sẽ tự động gọi lại hàm build() (ChangeNotifier)
    
    return ChangeNotifierProvider(
      // create: hàm để tạo state obj cho widget khi lần đầu tiên nó đc cần đến
      /// Sau khi Provider này tạo state, các widget con có thể sub vào và listen
      create: (context) => MyAppState(),
      // Widget child là 1 widget MaterialApp: app theo Material design của Google
      /// Cả app chỉ nên có 1 widget này, nó quy định nhiều field global cho appp
      child: MaterialApp(
        // Tên của app hiển thị bên OS
        title: 'Namer App',
        // Chọn theme theo màu trong catalog của Material
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // home: widget đầu tiên đc load khi app start
        home: MyHomePage(),
      ),
    );
  }
}

// State class của app, mix từ ChangeNotifier
class MyAppState extends ChangeNotifier {
  // Get 1 từ random (từ package english_words)
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();  // Trigger change state
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sub vào state obj MyAppState, nếu bên kia gọi notifyChange, widget này sẽ rebuild
    var appState = context.watch<MyAppState>();
    var pair = appState.current; 

    // Scaffold: 1 layout widget bên trong chứa các hàng, cột
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random Bruh idea:'),
            // Get data từ state obj
            BigCard(pair: pair),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print('button pressed!');
                appState.getNext(); // Change state
              },
              child: Text('Next'),  // Label của button
            )],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // Lấy data về Theme hiện tại của app
    final theme = Theme.of(context);
    // textTheme: data về phần text trong Theme
    // displayMedium: phần text Display, hay biểu diễn các nội dung ngắn, quan trọng
    // copyWith: copy toàn bộ field của data đó, nhưng override lại color
    // !: vì Flutter k cho gọi hàm trên các obj có thể null (báo lỗi), nên dùng ! khi tự tin k null
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // Set màu cho card là màu primary của theme hiện tại
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style, 
          // Field giúp các app Screen Reader đọc text theo 1 cách khác
          semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}