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
}
