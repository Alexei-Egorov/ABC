import UIKit

protocol CityHeaderDelegate: AnyObject {
    func textDidChange(text: String)
}

final class CityHeader: UITableViewHeaderFooterView {
    
    static let cellname = "CityHeader"
    
    weak var delegate: CityHeaderDelegate?
    
    // MARK: - UI Properties
    
    let searchTextField: UISearchTextField = {
        let textField = UISearchTextField().disableAutoresizingMask()
        textField.placeholder = Strings.search
        textField.autocapitalizationType = .none
        textField.backgroundColor = .appTFGray
        return textField
    }()
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        contentView.backgroundColor = .clear
        searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func searchTextChanged(_ textField: UISearchTextField) {
        let text = textField.text ?? ""
        delegate?.textDidChange(text: text)
    }
}
