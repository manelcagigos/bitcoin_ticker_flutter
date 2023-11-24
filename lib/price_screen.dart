import 'package:bitcoin_ticker_flutter/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;

  List<CryptoModel>? listOfCryptoModel;

  CoinData coinData = CoinData();

  @override
  void didChangeDependencies() async {
    listOfCryptoModel = <CryptoModel>[];
    for (String coin in cryptoList) {
      await Future.delayed(const Duration(seconds: 2));
      await getData(coin);
    }
    super.didChangeDependencies();
  }

  Future<void> getData(String coin) async {
    dynamic data = await coinData.getCoinData(coin, selectedCurrency);

    String nameCoin = 'No value';
    double rate = 0.0;

    // Check if the data is not null and contains required keys
    if (data != null &&
        data.containsKey('asset_id_base') &&
        data.containsKey('rate')) {
      nameCoin = data['asset_id_base'];
      rate = data['rate'];
    }

    listOfCryptoModel!.add(CryptoModel(nameCoin: nameCoin, rate: rate));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Coin Ticker'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListView.builder(
            itemCount: listOfCryptoModel!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ${listOfCryptoModel![index].nameCoin} = ${listOfCryptoModel![index].rate.toInt()} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                _buildDropdown(), //we can also user the ternary operator: Plataform.isIOS ? _buildCupertinoPicker() : _buildDropDownButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    if (Platform.isIOS) {
      return _buildCupertinoPicker();
    } else {
      return _buildDropdownButton();
    }
  }

  Widget _buildDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      dropdownColor: Colors.lightBlueAccent,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white, // Customize underline color here
              width: 2, // Customize underline width here
            ),
          ),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          if (newValue != null) {
            int index = currenciesList.indexOf(newValue);
            if (index != -1) {
              listOfCryptoModel!.clear();
              selectedCurrency = currenciesList[index];
              for (String coin in cryptoList) {
                getData(coin);
              }
            }
          }
        });
      },
      items: currenciesList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCupertinoPicker() {
    return Container(
      height: 200.0,
      color: Colors.white,
      child: CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int index) {
          setState(() {
            selectedCurrency = currenciesList[index];
            for (String coin in cryptoList) {
              getData(coin);
            }
          });
        },
        children: List<Widget>.generate(
          currenciesList.length,
          (int index) {
            return Center(
              child: Text(
                currenciesList[index],
                style: const TextStyle(fontSize: 20.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
