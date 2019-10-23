# AlisterSwift

[![Version](https://img.shields.io/cocoapods/v/Alister.svg?style=flat)](https://cocoapods.org/pods/AlisterSwift)
[![License](https://img.shields.io/cocoapods/l/Alister.svg?style=flat)](https://cocoapods.org/pods/AlisterSwift)
[![Platform](https://img.shields.io/cocoapods/p/Alister.svg?style=flat)](https://cocoapods.org/pods/AlisterSwift)

# Overview
`Alister` allows to manage the content of any `UITableView` or `UICollectionView`.
The general idea is provide a layer that synchronizes data with the cell appearance for such operations like adding, moving, deleting and reordering.
Alister automatically handle `UITableView` and `UICollectionView` data source and delegates protocols and you can override them by subclassing from base controllers.

# Features
- Works with `UITableView` and `UICollectionView`
- Supports all operations for sections and rows such as `Insert`, `Delete`, `Move`, `Reload`
- Supports `UISearchBar` and provide search predicate
- Supports custom header and footer views
- Provides keyboard handling
- Provides bottom sticked footer as part of `ANTableView`

# Usage
#### Initialize list controller
```
private let controller: TableController
...
init() {
	controller = TableController(tableView: tableView)
	super.init(nibName: nil, bundle: nil)
}
```

#### Register cells, headers and footers

```
controller.configureCells { (config) in
	config.register(cell: CarCell.self, for: CarCellViewModel.self)
	config.register(footer: CarsTableHeaderFooter.self, for: CarsTableHeaderFooterVM.self)
	config.register(header: CarsTableHeaderFooter.self, for: CarsTableHeaderFooterVM.self)
}
```

#### Add models to storage
```
controller.storage.update { [unowned self] (update) in

	// Adding rows to the table
	update.add(modelsSection1)
	update.add(modelsSection2, to: 1)

	// Adding header and footer to some sections
	update.update(headerModel: CarsTableHeaderFooterVM(title: "Section 0 Header"), section: 0)
	update.update(headerModel: CarsTableHeaderFooterVM(title: "Section 1 Header"), section: 1)
	update.update(footerModel: CarsTableHeaderFooterVM(title: "Section 1 Footer"), section: 1)
}
```

#### Add Searchbar
```
controller.attachSearchBar(searchBar)
```
and that's it!

#### Handle selection
**Option 1: ViewModel style**
```
model.selection = {
	self.showAlert(title: model.alertTitle)
}
```

**Option 2: Controller style**
```
tableController.selection = { viewModel, indexPath in
	...
}
```
See more on this and other features in the *Example* project

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Requirements
Xcode 8+, Swift 4+.

## Installation

AlisterSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlisterSwift'
```

## Authors

Oksana Kovalchuk, oksana@anoda.mobi <br>
Alexander Kravchenko, alex.kravchenko@anoda.mobi <br>
Maxim Danilov, maxim.danilov@anoda.mobi <br>
Pavel Mosunov, pavel.mosunov@anoda.mobi <br>
Simon Kostenko, simon.kostenko@anoda.mobi

## License

AlisterSwift is available under the MIT license. See the LICENSE file for more info.
