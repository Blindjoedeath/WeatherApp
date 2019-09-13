//
//  LocationViewSpy.swift
//  WeatherTests
//
//  Created by Oskar on 13/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class LocationViewSpy: LocationViewProtocol{
    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: LocationPresenterProtocol?
    var invokedPresenterList = [LocationPresenterProtocol?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: LocationPresenterProtocol!
    var presenter: LocationPresenterProtocol! {
        set {
            invokedPresenterSetter = true
            invokedPresenterSetterCount += 1
            invokedPresenter = newValue
            invokedPresenterList.append(newValue)
        }
        get {
            invokedPresenterGetter = true
            invokedPresenterGetterCount += 1
            return stubbedPresenter
        }
    }
    var invokedIsNextNavigationEnabledSetter = false
    var invokedIsNextNavigationEnabledSetterCount = 0
    var invokedIsNextNavigationEnabled: Bool?
    var invokedIsNextNavigationEnabledList = [Bool]()
    var invokedIsNextNavigationEnabledGetter = false
    var invokedIsNextNavigationEnabledGetterCount = 0
    var stubbedIsNextNavigationEnabled: Bool! = false
    var isNextNavigationEnabled: Bool {
        set {
            invokedIsNextNavigationEnabledSetter = true
            invokedIsNextNavigationEnabledSetterCount += 1
            invokedIsNextNavigationEnabled = newValue
            invokedIsNextNavigationEnabledList.append(newValue)
        }
        get {
            invokedIsNextNavigationEnabledGetter = true
            invokedIsNextNavigationEnabledGetterCount += 1
            return stubbedIsNextNavigationEnabled
        }
    }
    var invokedIsPermissionNotificationEnabledSetter = false
    var invokedIsPermissionNotificationEnabledSetterCount = 0
    var invokedIsPermissionNotificationEnabled: Bool?
    var invokedIsPermissionNotificationEnabledList = [Bool]()
    var invokedIsPermissionNotificationEnabledGetter = false
    var invokedIsPermissionNotificationEnabledGetterCount = 0
    var stubbedIsPermissionNotificationEnabled: Bool! = false
    var isPermissionNotificationEnabled: Bool {
        set {
            invokedIsPermissionNotificationEnabledSetter = true
            invokedIsPermissionNotificationEnabledSetterCount += 1
            invokedIsPermissionNotificationEnabled = newValue
            invokedIsPermissionNotificationEnabledList.append(newValue)
        }
        get {
            invokedIsPermissionNotificationEnabledGetter = true
            invokedIsPermissionNotificationEnabledGetterCount += 1
            return stubbedIsPermissionNotificationEnabled
        }
    }
    var invokedIsLocalityButtonEnabledSetter = false
    var invokedIsLocalityButtonEnabledSetterCount = 0
    var invokedIsLocalityButtonEnabled: Bool?
    var invokedIsLocalityButtonEnabledList = [Bool]()
    var invokedIsLocalityButtonEnabledGetter = false
    var invokedIsLocalityButtonEnabledGetterCount = 0
    var stubbedIsLocalityButtonEnabled: Bool! = false
    var isLocalityButtonEnabled: Bool {
        set {
            invokedIsLocalityButtonEnabledSetter = true
            invokedIsLocalityButtonEnabledSetterCount += 1
            invokedIsLocalityButtonEnabled = newValue
            invokedIsLocalityButtonEnabledList.append(newValue)
        }
        get {
            invokedIsLocalityButtonEnabledGetter = true
            invokedIsLocalityButtonEnabledGetterCount += 1
            return stubbedIsLocalityButtonEnabled
        }
    }
    var invokedIsDataLoadingIndicatorEnabledSetter = false
    var invokedIsDataLoadingIndicatorEnabledSetterCount = 0
    var invokedIsDataLoadingIndicatorEnabled: Bool?
    var invokedIsDataLoadingIndicatorEnabledList = [Bool]()
    var invokedIsDataLoadingIndicatorEnabledGetter = false
    var invokedIsDataLoadingIndicatorEnabledGetterCount = 0
    var stubbedIsDataLoadingIndicatorEnabled: Bool! = false
    var isDataLoadingIndicatorEnabled: Bool {
        set {
            invokedIsDataLoadingIndicatorEnabledSetter = true
            invokedIsDataLoadingIndicatorEnabledSetterCount += 1
            invokedIsDataLoadingIndicatorEnabled = newValue
            invokedIsDataLoadingIndicatorEnabledList.append(newValue)
        }
        get {
            invokedIsDataLoadingIndicatorEnabledGetter = true
            invokedIsDataLoadingIndicatorEnabledGetterCount += 1
            return stubbedIsDataLoadingIndicatorEnabled
        }
    }
    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (title: String, message: String)?
    var invokedShowAlertParametersList = [(title: String, message: String)]()
    func showAlert(title: String, message: String) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (title, message)
        invokedShowAlertParametersList.append((title, message))
    }
    var invokedSetDate = false
    var invokedSetDateCount = 0
    var invokedSetDateParameters: (date: String, Void)?
    var invokedSetDateParametersList = [(date: String, Void)]()
    func setDate(_ date: String) {
        invokedSetDate = true
        invokedSetDateCount += 1
        invokedSetDateParameters = (date, ())
        invokedSetDateParametersList.append((date, ()))
    }
    var invokedSetDay = false
    var invokedSetDayCount = 0
    var invokedSetDayParameters: (day: String, Void)?
    var invokedSetDayParametersList = [(day: String, Void)]()
    func setDay(_ day: String) {
        invokedSetDay = true
        invokedSetDayCount += 1
        invokedSetDayParameters = (day, ())
        invokedSetDayParametersList.append((day, ()))
    }
    var invokedSetCity = false
    var invokedSetCityCount = 0
    var invokedSetCityParameters: (city: String, Void)?
    var invokedSetCityParametersList = [(city: String, Void)]()
    func setCity(_ city: String) {
        invokedSetCity = true
        invokedSetCityCount += 1
        invokedSetCityParameters = (city, ())
        invokedSetCityParametersList.append((city, ()))
    }
    var invokedSetCities = false
    var invokedSetCitiesCount = 0
    var invokedSetCitiesParameters: (cities: [String], Void)?
    var invokedSetCitiesParametersList = [(cities: [String], Void)]()
    func setCities(_ cities: [String]) {
        invokedSetCities = true
        invokedSetCitiesCount += 1
        invokedSetCitiesParameters = (cities, ())
        invokedSetCitiesParametersList.append((cities, ()))
    }
}
