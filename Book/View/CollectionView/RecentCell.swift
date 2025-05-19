import Foundation
import UIKit
import SnapKit

class RecentCell: UICollectionViewCell {
    static let id = "RecentCell"
    private var recentImages: [RecentImage] = []
    // 셀에서 모달을 띄우기 위한 부모 뷰 컨트롤러 참조
    weak var parentViewController: UIViewController?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.alignment = .center
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .white
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    func reloadData() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let recentImage = CoreDataManage.shared.fetchRecentImage()
        self.recentImages = recentImage
        
        for (index, image) in recentImage.enumerated() where index < 10 {
            guard let urlString = image.thumbnail, let url = URL(string: urlString) else { continue }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
            imageView.snp.makeConstraints { $0.width.height.equalTo(100) }
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }.resume()
            stackView.addArrangedSubview(imageView)
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        print("이미지 클릭")
        guard let imageView = sender.view as? UIImageView else { return }
        // 어떤 이미지를 클릭했는지 확인
        let index = imageView.tag
        // 배열 접근 안전성 확보
        guard index < recentImages.count else {return}
        // 해당 이미지의 실제 데이터를 얻기
        let recent = recentImages[index]
        let modalVC = ModalViewController()
        
        modalVC.book = Book(
            title: recent.title ?? "",
            contents: recent.contents ?? "", authors: (recent.authors ?? "").components(separatedBy: ", "),
            salePrice: Int(recent.price ?? "") ?? 0, thumbnail: recent.thumbnail ?? ""
        )
        parentViewController?.present(modalVC, animated: true)
    }
}

