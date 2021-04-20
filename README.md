# coingecko_dart

A Dart/Flutter Wrapper for the CoinGecko API (V3).

## GET STARTED

### ADD DEPENDENCY

```yaml
  dependencies:
    coingecko_dart: ^0.1.0
```

### EASY TO USE

To get started with the api, all you have to do is initialize it like so and call the method of your choice!

```dart
    CoinGeckoApi apiInstance = CoinGeckoApi();
    //Future<CoinGeckoResult> result = await apiInstance.callMethod();
```

## METHODS AVAILABLE

#### GENERAL

```dart
    ping()                      -> /ping
```

***Example***

```dart
    Future<CoinGeckoResult<bool>> pingResponse = await apiInstance.ping();
    bool requestIsSuccessful = pingResponse.data;
```

#### /SIMPLE

```dart
- simplePrice()                 -> /simple/price
- simpleTokenPrice()            -> /simple/token_price/{id}
- simpleSupportedVsCurrencies() -> /simple/supported_vs_currencies
```

##### RETURN TYPES

respectively matching the above methods

- `CoinGeckoResult<List<PricedCoin>>`
- `CoinGeckoResult<List<SimpleToken>>`
- `CoinGeckoResult<List<String>>`

***[Example](#simple_example)***

#### /COINS

```dart
    1. listCoins()                   -> /coins/list
    2. getCoinMarkets()              -> /coins/markets
    3. getCoinData()                 -> /coins/{id}
    4. getCoinTickers()              -> /coins/{id}/tickers
    5. getCoinHistory()              -> /coins/{id}/history
    6. getCoinMarketChart()          -> /coins/{id}/market_chart
    7. getCoinMarketChartRanged()    -> /coins/{id}/market_chart/range
```

##### RETURN TYPES

respectively matching the above methods

1.    `CoinGeckoResult<List<Coin>>`
2.    `CoinGeckoResult<List<FullCoin>>`
3.    ** **`CoinGeckoResult<Coin>`**
4.    `CoinGeckoResult<List<CoinTicker>>`
5.    ** **`CoinGeckoResult<Coin>`**
6.    `CoinGeckoResult<List<CoinDataPoint>>`
7.    `CoinGeckoResult<List<CoinDataPoint>>`

** (3,5) 
_[Note: Data class is not fully implemented, use ( coin.json[ ] ) property instead to access the object directly]_

***[Example](#coins_example)***

#### /CONTRACT

```dart
    getContractTokenData()        -> /coins/{id}/contract/{contract_address}
    getContractMarketChart()      -> /coins/{id}/contract/{contract_address}/market_chart
    getContractMarketChartRanged()-> /coins/{id}/contract/{contract_address}/market_chart/range
```

#### /EXCHANGES

```dart
    getExchanges()                -> /exchanges
    getExchangeRatesBtc()         -> /exchange_rates
```

#### /TRENDING

```dart
    getSearchTrending()           -> /search/trending
```

#### /GLOBAL

```dart
    getGlobalCoins()              -> /global
    getGlobalDefi()               -> /global/decentralized_finance_defi
```


## EXAMPLES

#### SIMPLE_EXAMPLE

```dart
    1. CoinGeckoResult<List<PricedCoin>> result = await api.simplePrice(
        ids: ["iota"],
        vs_currencies: ["usd", "jpy"],
        includeLastUpdatedAt: true,
        includeMarketCap: true);
    //obtain prices and some other data of "iota" coin in "jpy" and "usd"
```

You can use `var` to store the result if you're not too sure about the return data type.

```dart
    2. var result = await api.simpleTokenPrice(
        id: 'ethereum',
        contractAddresses: ['0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9'],
        vs_currencies: ['inr', 'usd', 'eth']);
       //CoinGeckoResult<List<SimpleToken>>
       //obtain price and some other data of ethereum token "AAVE" in 'inr','usd' and 'eth'

    3. var result = await api.simpleSupportedVsCurrencies(); 
       //CoinGeckoResult<List<String>>
       //list of currencies against crypto ex: ['usd','inr','jpy','cad']
```

#### COINS_EXAMPLE

```dart
    1. var result = await api.listCoins(includePlatformFlag: false);
       //result.data contains a list of Coin() objects
       print(result.data.any((element) => element.symbol.toUpperCase() == "BTC"));
       //true
    
    2. var result = await api.getCoinMarkets(
        vsCurrency: 'usd',
        coinIds: ['bitcoin', 'iota', 'tether'],
        category: CoinCategories.STABLECOIN,
        sparkline: true,
        priceChangePercentage: [MarketInterval.T_1H, MarketInterval.T_24H]);
       //result.data contains a list of FullCoin() objects
       if(!result.isError)
        print(result.data.id[0]=="tether");
        //true
       else
        print("${result.errorCode}, ${result.errorMessage}");

    3. var result = await api.getCoinData(
        id: 'bitcoin', localization: true, sparkline: true);
       //obtain all data of crypto with id 'bitcoin' with localization and sparkline 7 days data

       //This object has to many different properties to warrant a data class of it's own, access json like so
       //do a pre-request to make sure you know the property name of the property value you need
       print(result.data.json['block_time_in_minutes'] == 10);
       //true

    4. var result = await api.getCoinTickers(
        id: "bitcoin",
        includeExchangeLogo: true,
       );
       //obtain tickers of crypto 'bitcoin'
       //result.data is a list that contains instances of `CoinTicker`  

    5. var result = await api.getCoinHistory(
        id: 'bitcoin', date: DateTime(2019, 4, 2));
       //obtain full data of bitcoin on 2nd April 2019

       //This object has to many different properties to warrant a data class of it's own, access json like so
       //do a pre-request to make sure you know the property name of the property value you need
       print(result.data.json['market_data']['current_price']['usd'] ==
            4146.321927706636);
       //true       

    6. var result = await api.getCoinMarketChart(
        id: "bitcoin", vsCurrency: "usd", days: 30,interval: ChartTimeInterval.DAILY);
       //a list of CoinDataPoint instances from 30 days back until now, one data point a day
       
    7. var result = await api.getCoinMarketChartRanged(
        id: "bitcoin",
        vsCurrency: "usd",
        from: DateTime(2021, 4, 2),
        to: DateTime(2021, 4, 10));
       //a list of CoinDataPoint instances between from Date and to Date
```

I'll now focus on adding better documentation for all this before implementing beta api functionality.
(Apr 18 21)
