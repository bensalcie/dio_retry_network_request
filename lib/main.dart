import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry_network_request/interceptors/dio_connectivity_request_retrier.dart';
import 'package:dio_retry_network_request/interceptors/retry_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Dio dio;
  late String firstPostTitle;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    firstPostTitle = 'Press the button 👇';
    isLoading = false;

    dio.interceptors.add(RetryInterceptor(
  dio: dio,
  logPrint: print, // specify log function
  retries: 7, // retry count
  retryDelays: const [
    Duration(seconds: 5), // wait 1 sec before first retry
    Duration(seconds: 15), // wait 2 sec before second retry
    Duration(seconds: 25),
    Duration(seconds: 35),
    Duration(seconds: 45),
    Duration(seconds: 55),
    Duration(seconds: 105),



     // wait 3 sec before third retry
  ],
));

    // dio.interceptors.add(RetryOnConnectionInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(dio: Dio(),
    //    connectivity: Connectivity())));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isLoading)
              CircularProgressIndicator()
            else
              Text(
                firstPostTitle,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            RaisedButton(
              child: Text('REQUEST DATA'),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final response =
                    await dio.get('https://jsonplaceholder.typicode.com/posts');
                setState(() {
                  firstPostTitle = response.data[0]['title'] as String;
                  isLoading = false;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}