# Quant Trading iPhone App

This repo contains a minimal SwiftUI skeleton for an iOS application that demonstrates how you might integrate OpenAI's ChatGPT with basic S&P 500 data and live market quotes.

## Features

- `TradingAgent` loads a small list of sample S&P 500 symbols and can fetch real-time prices.
- `OpenAIService` sends prompts to ChatGPT via the OpenAI API.
- The `ContentView` UI lets you type a question about trading strategies and displays ChatGPT's response. It can also show the latest quote for a selected stock symbol.

To build the app you need Xcode, an OpenAI API key available as the `OPENAI_API_KEY` environment variable, and an Alpha Vantage API key set as `ALPHA_VANTAGE_API_KEY` (it defaults to the public `demo` key).

```bash
# Example build (requires Xcode tools)
xcodebuild -scheme QuantTradingApp
```

This is still a minimal skeleton, so advanced trading logic is left as a placeholder, but the app now includes a simple example of retrieving live quotes from the Alpha Vantage API.
