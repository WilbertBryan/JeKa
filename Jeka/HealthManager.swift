//
//  HealthManager.swift
//  Jeka
//
//  Created by Wilbert Bryan Wibowo on 04/12/24.
//

import Foundation
import HealthKit

extension Date{
    static var startOfDay: Date{
        Calendar.current.startOfDay(for: Date())
    }
}
class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var steps: [String: Steps] = [:]
    @Published var todayStepCount: String = "0"
    @Published var todayCalories: String = "0"
    @Published var todayDistance: String = "0"
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories =  HKQuantityType(.activeEnergyBurned)
        let distance = HKQuantityType(.distanceWalkingRunning)
        let healthTypes: Set = [steps, calories, distance]
        
        Task{
            do {
                try await HKHealthStore().requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print ("Error fetching health data")
            }
        }
    }
    
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
                let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
                let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
                    guard let quantity = result?.sumQuantity(), error == nil else {
                        print("error fetching today's step data")
                        return
                    }
                    let stepCount = quantity.doubleValue(for: .count())
                    
                    // Store the step count as a string
                    DispatchQueue.main.async {
                        self.todayStepCount = stepCount.formattedString()
                        UserDefaults.standard.set(stepCount.formattedString(), forKey: "todayStepCount")
                    }
                    print(stepCount.formattedString())
                    print("ini dri healthManager", stepCount.formattedString())
                }
                healthStore.execute(query)
    }
    
    func fetchTodayCalories(){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's calories data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            
            // Store the calories as a string
            DispatchQueue.main.async {
                self.todayCalories = caloriesBurned.formattedString()
                UserDefaults.standard.set(caloriesBurned.formattedString(), forKey: "todayCalories")
            }
            print("ini dri healthManager calories", caloriesBurned.formattedString())
        }
        healthStore.execute(query)
    }
    
    func fetchTodayDistances(){
        let distances = HKQuantityType(.distanceWalkingRunning)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: distances, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's Distance data")
                return
            }
            
            let distance = quantity.doubleValue(for: .meter())
            DispatchQueue.main.async {
                self.todayDistance = distance.formattedString()
                UserDefaults.standard.set(distance.formattedString(), forKey: "todayDistances")
            }
            print("ini dri healthManager distance", distance.formattedString())
        }
        healthStore.execute(query)
    }
}

extension Double{
    func formattedString() -> String{
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        numberformatter.maximumFractionDigits = 0
        
        return numberformatter.string(from: NSNumber(value: self))!
    }
}
