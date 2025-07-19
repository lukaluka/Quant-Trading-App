import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct StockDataService {
    /// Fetch the latest quote for the given symbol using the Alpha Vantage API.
    /// The API key is read from the `ALPHA_VANTAGE_API_KEY` environment variable
    /// and falls back to Alpha Vantage's `demo` key for convenience.
    func fetchQuote(symbol: String, completion: @escaping (Result<Double, Error>) -> Void) {
        let apiKey = ProcessInfo.processInfo.environment["ALPHA_VANTAGE_API_KEY"] ?? "demo"
        guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let quote = json["Global Quote"] as? [String: Any],
                   let priceString = quote["05. price"] as? String,
                   let price = Double(priceString) {
                    completion(.success(price))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// Retrieve the last 200 daily closing prices for the given symbol. This
    /// helper is used by the sample moving average strategy in `TradingAgent`.
    func fetchDailyPrices(symbol: String, completion: @escaping (Result<[Double], Error>) -> Void) {
        let apiKey = ProcessInfo.processInfo.environment["ALPHA_VANTAGE_API_KEY"] ?? "demo"
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(symbol)&outputsize=compact&apikey=\(apiKey)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let series = json["Time Series (Daily)"] as? [String: Any] {
                    let prices: [Double] = series.compactMap { (_, value) -> Double? in
                        if let day = value as? [String: Any], let closeStr = day["4. close"] as? String {
                            return Double(closeStr)
                        }
                        return nil
                    }.sorted(by: >) // most recent first
                    completion(.success(Array(prices.prefix(200))))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
