import UIKit
import SnapKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let viewModel = ViewModel()
    private var searchResults: [Book] = []
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = "책이나 작가를 검색하세요"
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(RecentCell.self, forCellWithReuseIdentifier: RecentCell.id)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.id)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureUI()
        
        collectionView.isScrollEnabled = false
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [searchBar, collectionView ].forEach{ view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            // 공통 헤더 설정
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            switch sectionIndex {
            case 0:
                // 최근 검색어 셀 레이아웃 (가로 스크롤)
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(70)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous // 가로 스크롤
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
                section.boundarySupplementaryItems = [header]
                return section
                
            case 1:
                // 검색 결과 셀 레이아웃 (세로 스크롤은 테이블 뷰만)
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(300)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(600) // 고정된 높이 설정
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none // 세로 스크롤 유지
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
                section.boundarySupplementaryItems = [header]
                return section
                
            default:
                return nil
            }
        }
    }
    
    // UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            let alert = UIAlertController(title: "입력 오류", message: "검색어를 입력하세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        viewModel.fetchData(query: text) { [weak self] books in
            guard let self else { return }
            self.searchResults = books
            if books.isEmpty {
                let alert = UIAlertController(title: "검색 결과 없음", message: "검색 결과가 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                present(alert, animated: true)
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    // 서치바 텍스트가 비었을 경우 테이블 뷰 초기화
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            guard let query = searchBar.text else { return }
            viewModel.fetchData(query: query) { [weak self] books in
                guard let self = self else { return }
                self.searchResults = []
                self.collectionView.reloadData()
                
            }
        }
    }
    
    // CollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCell.id, for: indexPath) as? RecentCell else {
                return UICollectionViewCell()
            }
            cell.parentViewController = self
            cell.reloadData()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.id, for: indexPath) as? SearchCell else {
                return UICollectionViewCell()
            }
            cell.updateBooks(searchResults)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        // 헤더 뷰를 큐에서 가져옴
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as! SectionHeaderView
        
        // 섹션에 맞는 타이틀을 설정
        if indexPath.section == 0 {
            header.configure(with: "최근 검색어")
        } else {
            header.configure(with: "검색 결과")
        }
        
        return header
    }
    
}

extension SearchViewController: SearchCellDelegate {
    func didSelectBook(_ book: Book) {
        let modalVC = ModalViewController()
        modalVC.book = book
        present(modalVC, animated: true)
        collectionView.reloadData()
    }
}
