import Foundation

class ViewModel {
    private let apiKey = "3d20389e5ee3deb63dcd593f2e873d77"
    
    func fetchData(query: String, completion: @escaping ([Book]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(encodedQuery)&target=title"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("요청 실패: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            print(response.statusCode)
            guard let data = data else {
                print("데이터 없음")
                return
            }
            do {
                let result = try JSONDecoder().decode(BookResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(result.documents)
                }
            } catch {
                print("디코딩 오류: \(error)")
            }
        }.resume()
    }
}
