// ignore_for_file: prefer_const_constructors

import 'package:bitcoin_ticker/component/cryptoCard.dart';
import 'package:bitcoin_ticker/util/coin_data.dart';
import 'package:bitcoin_ticker/util/http_request.dart';
import 'package:bitcoin_ticker/util/private.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  List<String> coinValue = List.filled(3, '?');

  void getExchangerate() async {
    int index = 0;
    for (String crypto in cryptoList) {
      HttpRequest httpRequest = HttpRequest(
          url: '$path/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey');
      var data = await httpRequest.getData();
      setState(() {
        coinValue[index] = data['rate'].toStringAsFixed(0);
      });
      index++;
    }
  }

  @override
  void initState() {
    super.initState();
    getExchangerate();
  }

  List<CryptoCard> cryptoCardList() {
    List<CryptoCard> cryptoCardList = [];
    for (String crypto in cryptoList) {
      int index = 0;
      CryptoCard cryptoCard = CryptoCard(
        coinName: crypto,
        coinValue: coinValue[index],
        selectedCurrency: selectedCurrency,
      );
      cryptoCardList.add(cryptoCard);
      index++;
    }
    return cryptoCardList;
  }

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currnecy in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(currnecy),
        value: currnecy,
      );
      dropdownItems.add(item);
    }
    // Android style
    return DropdownButton(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
          });
          getExchangerate();
        });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currnecy in currenciesList) {
      pickerItems.add(Text(currnecy));
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getExchangerate();
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoCardList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
