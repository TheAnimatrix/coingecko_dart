# coingecko_dart

A Dart/Flutter Wrapper for the CoinGecko API (V3).

What's implemented so far:
GET /ping
GET /coins/list

What's remaining:
Everything else except the beta features.

* USAGE:
```
    CoinGeckoApi apiInstance = CoinGeckoApi();
    CoinGeckoResult pingResult = apiInstance.ping();
    CoinGeckoResult coinListResult = apiInstance.listCoins();
```

1. use CoinGeckoResult.isSuccess to verify if the request was successful.
2. Coin list data of type List<Coin> can be accessed using <coinListResult>.coinList;