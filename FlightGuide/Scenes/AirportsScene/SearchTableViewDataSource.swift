//
//  SearchTableDataSource.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 31.05.2023.
//

import RxDataSources
import Foundation
import UIKit

enum SectionedTableModel {
    case citiesSection(title: String, items: [SectionItem])
    case airportsSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case cityItem(viewModel: CityCellViewModel)
    case airportItem(viewModel: AirportCellViewModel)
}

extension SectionedTableModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .citiesSection(_, let items):
            return items.map { $0 }
        case .airportsSection(_, let items):
            return items.map { $0 }
        }
    }
    
    
    init(original: SectionedTableModel, items: [SectionItem]) {
        switch original {
        case .citiesSection(let title, let items):
            self = .citiesSection(title: title, items: items)
        case .airportsSection(let title, let items):
            self = .airportsSection(title: title, items: items)
        }
    }
}

extension SectionedTableModel {
    var title: String {
        switch self {
        case .citiesSection(let title, _):
            return title
        case .airportsSection(let title, _):
            return title
        }
    }
}

final class SearchTableViewDataSource: RxTableViewSectionedReloadDataSource<SectionedTableModel> {
    
    init() {
        super.init(configureCell: SearchTableViewDataSource.cellConfig)
        titleForHeaderInSection = { dataSource, index in
            let section = dataSource[index]
            return section.title
        }
    }
    
    private static var cellConfig: TableViewSectionedDataSource<SectionedTableModel>.ConfigureCell {
        return { dataSource, tableView, indexPath, type in
            switch dataSource[indexPath] {
            case let .cityItem(viewModel):
                if let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier,
                                                            for: indexPath) as? CityCell {
                    cell.viewModel = viewModel
                    return cell
                }
            case let .airportItem(viewModel):
                if let cell = tableView.dequeueReusableCell(withIdentifier: AirportCell.identifier,
                                                            for: indexPath) as? AirportCell {
                    cell.viewModel = viewModel
                    return cell
                }
            }
            return UITableViewCell()
        }
    }
    
}
