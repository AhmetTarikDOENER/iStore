import UIKit

final class TodayAppExpandedTableViewController: UITableViewController {
    
    var dismissHandler: (() -> Void)?
    var todayItem: TodayCellItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        prepareTableView()
    }
    
    private func prepareTableView() {
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    @objc private func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}

extension TodayAppExpandedTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headerCell = TodayAppExpandedHeaderCell()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.clipsToBounds = true
            return headerCell
        }
        let cell = TodayAppExpandedDescriptionTableViewCell()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayCollectionViewController.cellSize
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
