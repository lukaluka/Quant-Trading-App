import SwiftUI

struct ContentView: View {
    @StateObject private var agent = TradingAgent()
    @State private var query: String = "latest trading strategies"
    @State private var response: String = ""
    @State private var symbol: String = "AAPL"
    @State private var priceText: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Ask ChatGPT", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Run Query") {
                    agent.askChatGPT(prompt: query) { result in
                        switch result {
                        case .success(let text):
                            response = text
                        case .failure(let error):
                            response = error.localizedDescription
                        }
                    }
                }
                .padding(.vertical)

                HStack {
                    TextField("Symbol", text: $symbol)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Get Price") {
                        agent.fetchPrice(symbol: symbol) { result in
                            switch result {
                            case .success(let price):
                                priceText = String(format: "%.2f", price)
                            case .failure(let error):
                                priceText = error.localizedDescription
                            }
                        }
                    }
                }
                .padding(.bottom)

                if !priceText.isEmpty {
                    Text("Latest price for \(symbol): \(priceText)")
                        .padding(.bottom)
                }

                ScrollView {
                    Text(response)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Quant Trading")
            .onAppear {
                agent.loadSP500()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
