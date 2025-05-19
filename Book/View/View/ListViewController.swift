import UIKit
import SnapKit

class ListViewController: UIViewController {
    let coreDataManager = CoreDataManage.shared
    
    private var books: [BookData] = []
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    private let Label: UILabel = {
        let label = UILabel()
        label.text = "담은 책"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return stackView
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    // 얜 한 번만 불림
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    // 얜 화면이 보일 때마다 불림
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        books = coreDataManager.fetchBooks()
        print(books)
        tableView.reloadData()
        emptyBook()
    }
    private func configureUI() {
        view.backgroundColor = .white
        [deleteButton, Label, addButton].forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
        view.addSubview(tableView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    func emptyBook(){
        if CoreDataManage.shared.fetchBooks().isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "책을 담아주세요!"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 16)
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
    }
    @objc func deleteButtonTapped() {
        coreDataManager.deleteAllData()
        books = coreDataManager.fetchBooks()
        tableView.reloadData()
        emptyBook()
    }
    
    @objc func addButtonTapped() {
        tabBarController?.selectedIndex = 0
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(books.count)
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        let book = books[indexPath.row]
        cell.configureCell(with: book)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
}
