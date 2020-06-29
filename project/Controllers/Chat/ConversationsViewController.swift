import UIKit
import PromiseKit

class ConversationsViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var segmentControll: SegmentControll!

    private var dataSource: SegmentDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
            
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(cell: ConversationTableViewCell.self)
        
        setupDataSource()
        setUpSegmentControll()
    }
    
    fileprivate func setUpSegmentControll() {
        segmentControll.setLeft(NSLocalizedString("PRIVATE TALKS", comment: ""))
        segmentControll.setRight(NSLocalizedString("ALL TALKS", comment: ""))
        
        segmentControll.selector = {[unowned self] index in
            self.dataSource?.selectIndex = index
        }
    }
    
    fileprivate func setupDataSource() {
        showActivityIndicator()
        
        firstly { when(fulfilled: CompanyDataProvider.default().getMyCommented(),       ConversationsDataProvider.default().get())}
            .done { myCommented, conversetiones in
                
                conversetiones.items.sort(by: { $0.last!.date > $1.last!.date })
                var conversetion = ConversationDataSource(data: conversetiones.items)
                conversetion.selectors[.select] = { [unowned self] _, _, item in
                    self.message(item)
                }
                
                var myCommented = myCommented
                myCommented.sort(by: { $0.latestComment!.date > $1.latestComment!.date })
                var company = ConversationByCompanyDataSource(data: myCommented)
                company.selectors[.select] = { [unowned self] _, _, item in
                    self.message(item)
                }
                
                self.dataSource = SegmentDataSourceShim([conversetion, company], tableView: self.tableView)
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    }
    
    private func message(_ conversation: Conversation) {
        let chat = InvestorsChatViewController()
        chat.coversetionID = conversation.id
        navigationController?.pushViewController(chat, animated: true)
    }
    
    private func message(_ company: CompanyModel) {
        let chat = CompanyChatViewController()
        chat.company = company
        navigationController?.pushViewController(chat, animated: true)
    }
}

struct ConversationDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable
{
    var data: [Conversation]
    
    var selectors: [DataSource.Action: (ConversationTableViewCell, IndexPath, Conversation) -> ()] = [:]

    init(data: [Conversation]) {
        self.data = data
    }
    
    func configurateCell(_ cell: ConversationTableViewCell, item: Conversation, at indexPath: IndexPath) {
        cell.names.text = item.peers.compactMap{ $0.fullName() }.joined(separator: ", ")
        cell.date.text = item.created.toString(style: .short)
        cell.message.text = item.last?.text
    }
}

struct ConversationByCompanyDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable
{
    var data: [CompanyModel]
    
    var selectors: [DataSource.Action: (ConversationTableViewCell, IndexPath, CompanyModel) -> ()] = [:]
    
    init(data: [CompanyModel]) {
        self.data = data
    }
    
    func configurateCell(_ cell: ConversationTableViewCell, item: CompanyModel, at indexPath: IndexPath) {
        cell.names.text = item.name
        cell.date.text = item.latestComment?.date.toString(style: .short)
        cell.message.text = item.latestComment?.text
    }
}

