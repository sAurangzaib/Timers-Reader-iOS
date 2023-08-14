
import UIKit

class UITableViewFactory {
    
    class func createUITableView<T: UITableView>(delegate: UITableViewDelegate? = nil, separatorStyle:UITableViewCell.SeparatorStyle = .none, rowHeight:CGFloat = UITableView.automaticDimension, contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never) -> T {
        
        let tableView = T()
        tableView.separatorStyle = separatorStyle
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = 44
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        tableView.delegate = delegate
        return tableView
    }
}
