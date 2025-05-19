import CoreData
import Foundation

class CoreDataManage {
    
    static let shared = CoreDataManage()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Book")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("데이터 세이브 완료")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveBook(title: String, authors: String, price: String) {
        let context = persistentContainer.viewContext
        let bookData = BookData(context: context)
        bookData.title = title
        bookData.authors = authors
        bookData.price = price
        saveContext()
    }
    
    func saveImage(title: String, authors: String, price: String, thumbnail: String, contents: String) {
        let context = persistentContainer.viewContext
        let recentImage = RecentImage(context: context)
        recentImage.thumbnail = thumbnail
        recentImage.title = title
        recentImage.authors = authors
        recentImage.price = price
        recentImage.contents = contents
        saveContext()
    }
    
    func deleteAllData() {
        let context = persistentContainer.viewContext
        let model = persistentContainer.managedObjectModel
        
        for entity in model.entities {
            guard let name = entity.name else { continue }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            do {
                try context.execute(deleteRequest)
                print("모든 \(name) 데이터 삭제 완료")
            } catch {
                print("삭제 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchBooks() -> [BookData] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BookData>(entityName: "BookData")
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("불러오기 실패: \(error)")
            return []
        }
    }
    
    func fetchRecentImage() -> [RecentImage] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RecentImage>(entityName: "RecentImage")
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("불러오기 실패: \(error)")
            return []
        }
    }
    
}
