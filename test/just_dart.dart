
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';
import 'dart:io';

void main()
{
  CoinGeckoApi api = CoinGeckoApi(rateLimitManagement: true);
  test('gecko rate limit test',() async {

    while(true){
      print("pinging @ ${DateTime.now()} ${api.requestCount}");
      await api.ping();
    }

  },timeout: Timeout(Duration(minutes: 2)));
}