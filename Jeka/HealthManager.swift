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
    
    //func for chart
    func fetchWeeklySteps(completion: @escaping ([Step]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        let interval = DateComponents(day: 1)
        let startDate = calendar.date(byAdding: .day, value: -6, to: Date.startOfDay)!
        let anchorDate = calendar.startOfDay(for: Date())
        
        let query = HKStatisticsCollectionQuery(
            quantityType: steps,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching weekly step data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var weeklySteps: [Step] = []
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                let stepCount = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                let date = statistics.startDate
                let day = DateFormatter().shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                weeklySteps.append(Step(day: day, count: Int(stepCount)))
            }
            
            DispatchQueue.main.async {
                completion(weeklySteps)
            }
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
