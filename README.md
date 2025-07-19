# Quant Trading iPhone App

This repo contains a minimal SwiftUI skeleton for an iOS application that demonstrates how you might integrate OpenAI's ChatGPT with basic S&P 500 data.

## Features

- `TradingAgent` loads a small list of sample S&P 500 symbols.
- `OpenAIService` sends prompts to ChatGPT via the OpenAI API.
- The `ContentView` UI lets you type a question about trading strategies and displays ChatGPT's response.

To build the app you need Xcode and an OpenAI API key available as the `OPENAI_API_KEY` environment variable.

```bash
# Example build (requires Xcode tools)
xcodebuild -scheme QuantTradingApp
```

This is just a skeleton, so many parts such as fetching real market data or implementing advanced trading logic are left as placeholders.
