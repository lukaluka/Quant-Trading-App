import Foundation

struct StockDataService {
    func fetchQuote(symbol: String, completion: @escaping (Result<Double, Error>) -> Void) {
        // Placeholder for fetching stock price
        // In a real app, integrate with a financial data API
        completion(.success(Double.random(in: 100...500)))
    }
}
