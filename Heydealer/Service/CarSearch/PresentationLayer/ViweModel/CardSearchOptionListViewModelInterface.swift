//
//  CardSearchOptionListViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Combine

enum CardSearchOptionListViewModelFlow {
    case nextOption(CardSearchOptionListViewModelInterface)
    case finishOption(CarListViewModel)
}

enum CardSearchOptionError: Error {
    case optionListEmpty
    case rangeOutException
}

protocol CardSearchOptionListViewModelInterface {
    var title: String { get }
    
    var selectedOption: CarSearchOptionItem? { get set }
    var optionList    : CurrentValueSubject<[CarSearchOptionItem]?, Never> { get  set }
    
    var searchFlow: PassthroughSubject<CardSearchOptionListViewModelFlow, Never> { get }
    
    func fetchOptionList() -> AnyPublisher<Never, Error>
    func didSelectOption(at index: Int) throws
}


