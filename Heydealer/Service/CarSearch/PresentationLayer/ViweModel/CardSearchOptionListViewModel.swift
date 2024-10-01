//
//  CardSearchOptionListViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Combine

protocol CardSearchOptionListViewModelInterface {
    var title: String { get }
    
    var selectedOption: CardSearchOptionItem? { get set }
    var optionList    : CurrentValueSubject<[CardSearchOptionItem]?, Never> { get  set }
}

protocol CardSearchOptionItem {
    var name    : String { get set }
    var optionID: String { get set }
}

class CardSearchOptionBrandListViewModel: CardSearchOptionListViewModelInterface {
    var title: String = "브랜드"
    
    var selectedOption: (any CardSearchOptionItem)?
    var optionList    : CurrentValueSubject<[any CardSearchOptionItem]?, Never> = CurrentValueSubject(nil)
    
    
    init() {
        
    }
}
