//
//  Created by Jordi Serra on 22/5/17.
//
//

public protocol ViewModelConfigurable: class {
    associatedtype VM
    func configure(for viewModel: VM)
}

public protocol ViewModelReusable: ViewModelConfigurable {
    static var reuseType: ReuseType { get }
    static var reuseIdentifier: String { get }
}

//MARK:- Types
public enum ReuseType {
    case nib(UINib)
    case classReference(AnyClass)
}

//MARK:- Extensions
extension ViewModelReusable {
    public static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
        
    }
    public static var reuseType: ReuseType {
        return .classReference(self)
    }
}
