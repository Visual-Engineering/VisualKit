//
//  Created by Jordi Serra on 22/5/17.
//
//

public protocol ViewModelConfigurable {
    associatedtype VM
    func configure(for viewModel: VM)
}
