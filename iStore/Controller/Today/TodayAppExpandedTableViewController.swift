import UIKit

final class TodayAppExpandedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
    }
}

extension TodayAppExpandedTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = UITableViewCell()
            let expandedCell = TodayCollectionViewCell()
            expandedCell.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(expandedCell)
            expandedCell.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            expandedCell.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            expandedCell.widthAnchor.constraint(equalToConstant: 250).isActive = true
            expandedCell.heightAnchor.constraint(equalToConstant: 250).isActive = true
            return cell
        }
        let cell = TodayAppExpandedDescriptionTableViewCell()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}
