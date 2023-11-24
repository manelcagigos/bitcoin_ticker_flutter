import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'apikey';
const coinApiBaseURL = 'https://rest.coinapi.io';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(String crypto, String currency) async {
    String requestURL =
        '$coinApiBaseURL/v1/exchangerate/$crypto/$currency?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(requestURL));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      // Handle the error case here if needed
      //print('Failed to fetch data: ${response.statusCode}');
      return null;
    }
  }
}
