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

Methods implemented so far:
```
    ping()                        -> /ping
    simplePrice()                 -> /simple/price
    simpleTokenPrice()            -> /simple/token_price/{id}
    simpleSupportedVsCurrencies() -> /simple/supported_vs_currencies
    listCoins()                   -> /coins/list
    getCoinMarkets()              -> /coins/markets
    getCoinData()                 -> /coins/{id}
    getCoinTickers()              -> /coins/{id}/tickers
    getCoinHistory()              -> /coins/{id}/history
    getCoinMarketChart()          -> /coins/{id}/market_chart
    getCoinMarketChartRanged()    -> /coins/{id}/market_chart/range

```

Only 11 more methods remaining to implement!!

Then I'll cover the documentation and make it more usable.
Once that's done i'll come back to the project and finish up the beta api's as well.

1. use CoinGeckoResult.isError to verify if the result was obtained.
2. if result doesn't have a specially tailored data class (.)raw property to query the object json