import UIKit

struct TodayCellItem {
    let category: String
    let title: String
    let description: String
    let image: UIImage
    let backgroundColor: UIColor
    
    let cellType: CellType
    
    enum CellType: String {
        case single, multiple
    }
}
