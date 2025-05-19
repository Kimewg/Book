import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    static let id = "SectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    func configure(with title: String) {
        self.titleLabel.text = title
    }
}

