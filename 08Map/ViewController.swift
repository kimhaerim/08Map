//
//  ViewController.swift
//  08Map
//
//  Created by 김해림 on 2021/03/04.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{
    //델리게이트 선언
    
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    //지도를 보여주기 위한 변수 선언
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        //공백으로 둠
        locationManager.delegate = self
        //상수 locationManger의 델리게이트를 self로 설정함
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //정확도를 최고로 설정
        locationManager.requestWhenInUseAuthorization()
        //위치 데이터를 추적하기 위해 사용자에게 승인을 구함
        locationManager.startUpdatingLocation()
        //위치 업데이트를 시작
        myMap.showsUserLocation = true
        //위치 보기 값을 true로 설정
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        //파라미터 : 위도값, 경도값, 범위
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        //위도값과 경도값을 매개변수로 CLLocationCoordinate2DMake함수를 호출
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        //범위 값을 매개변수로 MKCoordinateSpan호출
        let pResion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pResion, animated: true)
        return pLocation
    }
    
    //핀 설치를 위한 초기화하기
    func setAnnotation(latotudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        //핀을 설치하기 위한 함수를 호출
        annotation.coordinate = goLocation(latitudeValue: latotudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {  //위치가 업데이트 됐을 때 지도에 위치를 나타내기 위한 함수
        let pLocation = locations.last
        //위치가 업데이트 되면서 마지막 위치 값을 찾아냄
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        //마지막 위치의 위도,경도 값을 가지고 goLocation함수 호출, delta는 지도의 크기를 결정함
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            //placemarks의 첫 부분만 대입
            let country = pm!.country
            //나라 값을 대입
            var address: String = country!
            //country 상수의 값을 대입
            if pm!.locality != nil{
                //지역값이 존재하면 문자열에 추가함
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                //도로 값이 존재하면 문자열에 추가함
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
        })
        
        locationManager.stopUpdatingLocation()
        //위치가 업데이트되는 것을 멈춤
    }
   
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //현재 위치 표시
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        }
        else if sender.selectedSegmentIndex == 1{
            //폴리텍 대학 표시
            setAnnotation(latotudeValue: 37.751853, longitudeValue: 128.87605740000004, delta: 1, title: "한국폴리텍대학 강릉캠퍼스", subtitle: "강원도 강릉시 남산초교길 121")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "한국폴리텍대학 강릉캠퍼스"
        }
        else if sender.selectedSegmentIndex == 2 {
            //이지스퍼블리싱 표시
            setAnnotation(latotudeValue: 37.556876, longitudeValue: 126.914066, delta: 0.1, title: "이지스퍼블리싱", subtitle: "서울시 마포구 잔다리로 109 이지스 빌딩")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "이지스퍼블리싱 출판사"
        }
    }
    

}

