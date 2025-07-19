import Foundation

class TradingAgent: ObservableObject {
    @Published var sp500Symbols: [String] = []
    private var openAI: OpenAIService
    private let stockService = StockDataService()

    init() {
        // Set your API key here or load from environment
        self.openAI = OpenAIService(apiKey: ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "")
    }

    func fetchPrice(symbol: String, completion: @escaping (Result<Double, Error>) -> Void) {
        stockService.fetchQuote(symbol: symbol, completion: completion)
    }

    func loadSP500() {
        // Placeholder: In a real app, fetch the S&P 500 symbols from a data provider.
        sp500Symbols = ["AAPL", "MSFT", "GOOGL"]
    }

    func askChatGPT(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        openAI.chatCompletion(prompt: prompt, completion: completion)
    }

    /// Fetch recent prices and evaluate a simple moving average crossover.
    /// A buy signal is produced when the 50-day average closes above the
    /// 200-day average.
    func analyzeMovingAverage(symbol: String, completion: @escaping (Result<String, Error>) -> Void) {
        stockService.fetchDailyPrices(symbol: symbol) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let prices):
                guard prices.count >= 200 else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not enough data"])))
                    return
                }
                let ma50 = prices.prefix(50).reduce(0, +) / 50.0
                let ma200 = prices.prefix(200).reduce(0, +) / 200.0
                if ma50 > ma200 {
                    completion(.success("Buy signal: golden cross detected"))
                } else {
                    completion(.success("Sell signal: death cross detected"))
                }
            }
        }
    }
}
