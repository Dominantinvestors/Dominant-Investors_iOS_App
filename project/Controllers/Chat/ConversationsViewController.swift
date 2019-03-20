import UIKit

class ConversationsViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!

    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
            
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Conversations", comment: "")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(cell: ConversationTableViewCell.self)
        
        setupDataSource()
    }
    
    fileprivate func setupDataSource() {
        showActivityIndicator()
        ConversationsDataProvider.default().get { conversetiones, error in
            self.dismissActivityIndicator()
            if let conversetiones = conversetiones {
                var conversetion = ConversationDataSource(data: conversetiones)
                conversetion.selectors[.select] = { [unowned self] _, _, item in
                    self.message(item)
                }
                self.dataSource = TableViewDataSourceShim(conversetion)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    private func message(_ conversation: Conversation) {
        let chat = InvestorsChatViewController()
        chat.coversetionID = conversation.id
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

