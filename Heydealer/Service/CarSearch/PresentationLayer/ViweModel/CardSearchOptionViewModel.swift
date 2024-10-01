//
//  CardSearchOptionViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation
import Combine


class CardSearchOptionBrandListViewModel: CardSearchOptionListViewModelInterface {
    var title: String = "브랜드"
    
    var selectedOption: (CarSearchOptionItem)?
    var optionList    : CurrentValueSubject<[CarSearchOptionItem]?, Never> = CurrentValueSubject(nil)
    
    var searchFlow = PassthroughSubject<CardSearchOptionListViewModelFlow, Never>()
    
    private let getOptionListUsecase : GetCardSearchOptionBrandList
    private var cancelBags           = Set<AnyCancellable>()
    
    init() {
        getOptionListUsecase = .init(repository: CarServiceRepository(dataSource: AppEnvironment.shared.dataSource()))
    }
    
    func fetchOptionList() -> AnyPublisher<Never, any Error> {
        getOptionListUsecase.excute(nil)
            .map { [weak self] data in
                self?.optionList.send(data)
                return
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func didSelectOption(at index: Int) throws {
        guard let list = optionList.value, list.indices ~= index else { throw CardSearchOptionError.rangeOutException }
        
        
//        searchFlow.send(.nextOption(list[index]))
    }
}
