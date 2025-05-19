import UIKit
import SnapKit

class ModalViewController: UIViewController {
    var book: Book?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    private var authorsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    private var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        return button
    }()
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        modalPresentationStyle = .overFullScreen
        [
            titleLabel,
            authorsLabel,
            thumbnailImageView,
            priceLabel,
            contentsLabel,
            closeButton,
            saveButton
        ].forEach{ view.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        authorsLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorsLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.equalToSuperview().offset(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalToSuperview().offset(-40)
        }
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    private func configureData() {
        guard let book = book else { return }
        titleLabel.text = book.title
        authorsLabel.text = "\(book.authors.joined(separator: ", "))"
        priceLabel.text = "\(book.salePrice)"
        contentsLabel.text = "\(book.contents)"
        
        if let url = URL(string: book.thumbnail) {
            // 간단한 이미지 로딩 (URLSession 사용)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

    }
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSave() {
        CoreDataManage.shared.saveBook(title: titleLabel.text ?? "", authors: authorsLabel.text ?? "", price: priceLabel.text ?? "")
        
        let alert = UIAlertController(title: "저장 완료", message: "\(titleLabel.text ?? "") 담기 완료!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
