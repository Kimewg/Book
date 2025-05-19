import UIKit

protocol SearchCellDelegate: AnyObject {
    func didSelectBook(_ book: Book)
}

class SearchCell: UICollectionViewCell {
    static let id = "SearchCell"
    private var dataSource: [Book] = []
    weak var delegate: SearchCellDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        tableView.rowHeight = 120
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(420)
        }
    }
    
    func updateBooks(_ books: [Book]) {
        self.dataSource = books
        tableView.reloadData()
        
        if books.isEmpty {
            let label = UILabel()
            label.text = "책을 검색해주세요!"
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            tableView.backgroundView = label
        }else {
            tableView.backgroundView = nil
        }
    }
    
}

extension SearchCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataSource.count)
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let book = dataSource[indexPath.row]
        print("Configuring cell with book: \(book.title)")
        cell.configureCell(with: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = dataSource[indexPath.row]
        _ = selectedBook.thumbnail
        CoreDataManage.shared.saveImage(
            title: selectedBook.title,
            authors: selectedBook.authors.joined(separator: ", "),
            price: String(selectedBook.salePrice),
            thumbnail: selectedBook.thumbnail,
            contents: selectedBook.contents
        )
        delegate?.didSelectBook(selectedBook)
    }
}

