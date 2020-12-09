//
//  Carousel.swift
//  BOMarket
//
//  Created by imac 2015 4k on 10/22/20.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

final class MyRecognizer: UIGestureRecognizer {
    
    var mainView: Carousel!
    
    public func setMainView(mainView: Carousel){
        self.mainView = mainView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        //super.touchesBegan(touches, with: event)
        if event.touches(for: self)?.count == 1, let touch = touches.first {
            mainView?.touchesBegan(startPoint: touch.location(in: mainView))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        //super.touchesMoved(touches, with: event)
        if event.touches(for: self)?.count == 1, let touch = touches.first {
            print("num: \(touches.count)")
            mainView?.touchesMoved(currrentPoint: touch.location(in: mainView))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        //super.touchesEnded(touches, with: event)
        mainView.touchesEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        print("cancel touch")
        //super.touchesCancelled(touches, with: event)
        mainView.touchesEnded()
    }
    
    
}

final class CarouselItem {
    
    let delegate: TimerSwitch
    
    let autoLayout = true
    
    let goNextSpeed = Double(1000)
    
    var containerWidth:CGFloat
    var containerHeight:CGFloat
    
    let container:UIView
    
    let maxTimeEplase:Double = 0.15
    
    
    public enum MoveDirection{
        case Left
        case Right
        case Center
    }
    
    var currentSide = MoveDirection.Center
    
    let xCarouselPading:CGFloat = 10
    let yCarouselPading:CGFloat = 10
    
    lazy var contentView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: imageName)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.contentMode = .scaleAspectFit
        contentView.layer.zPosition = 1
        if autoLayout{
            contentView.translatesAutoresizingMaskIntoConstraints = false
        }
        return contentView
    }()
    
    var translateOffet:CGFloat = 0
    
    let imageName:String
    
    private var headAnchor: NSLayoutConstraint!
    private var trailAnchor: NSLayoutConstraint!
    
    var startHead: CGFloat = 0
    var startTrail: CGFloat = 0
    var startPoint: CGPoint?
    
    var startFrame: CGRect?
    
    init(container: UIView, img: String, timerSwitch: TimerSwitch) {
        self.imageName = img
        self.container = container
        self.containerWidth = container.frame.size.width
        self.containerHeight = container.frame.size.height
        self.delegate = timerSwitch
    }
    
    public func GetUIImage() -> UIImageView {
        return contentView
    }
    
    public func InitAlinCenter(){
        currentSide = .Center
        if autoLayout{
            headAnchor = contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: xCarouselPading)
            trailAnchor = contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -xCarouselPading)
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: container.topAnchor, constant: yCarouselPading),
                contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -yCarouselPading),
                headAnchor,
                trailAnchor
            ])
        }else{
            AlinCenter()
        }
    }
    
    public func InitAlinLeft(){
        currentSide = .Left
        if autoLayout{
            headAnchor = contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: xCarouselPading - containerWidth)
            trailAnchor = contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -(xCarouselPading + containerWidth))
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: container.topAnchor, constant: yCarouselPading),
                contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -yCarouselPading),
                headAnchor,
                trailAnchor
            ])
        }else{
        }
    }
    
    public func InitAlinRight(){
        currentSide = .Right
        if autoLayout{
            headAnchor = contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: (xCarouselPading + containerWidth))
            trailAnchor = contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -xCarouselPading + containerWidth)
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: container.topAnchor, constant: yCarouselPading),
                contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -yCarouselPading),
                headAnchor,
                trailAnchor
            ])
        }else{
            let x = xCarouselPading + containerWidth
            let y = yCarouselPading
            contentView.frame = CGRect(x: x, y: y, width: containerWidth - 2*xCarouselPading, height: containerHeight-2*yCarouselPading)
        }
    }
    
    public func ResetView(containerWidth:CGFloat, containerHeight:CGFloat){
        if self.containerWidth != containerWidth || self.containerHeight != containerHeight{
            //print("resettttttttt\(containerWidth)")
            self.containerWidth = containerWidth
            self.containerHeight = containerHeight
            ResetPosition()
        }
    }
    
    func ResetPosition(){
        if autoLayout{
            if currentSide == .Center{
                AlinCenter()
            }else if currentSide == .Left{
                AlinLeft()
            }else if currentSide == .Right{
                AlinRight()
            }
        }else{
            if currentSide == .Center{
                InitAlinCenter()
            }else if currentSide == .Left{
                InitAlinLeft()
            }else if currentSide == .Right{
                InitAlinRight()
            }
        }
    }
    
    public func AlinCenter(){
        currentSide = .Center
        if autoLayout{
            headAnchor.constant = xCarouselPading
            trailAnchor.constant = -xCarouselPading
        }else{
            let x = xCarouselPading
            let y = yCarouselPading
            contentView.frame = CGRect(x: x, y: y, width: containerWidth - 2*xCarouselPading, height: containerHeight-2*yCarouselPading)
        }
    }
    
    public func AlinLeft(){
        currentSide = .Left
        if autoLayout{
            headAnchor.constant = xCarouselPading - containerWidth
            trailAnchor.constant = -(xCarouselPading + containerWidth)
        }else{
            let x = xCarouselPading - containerWidth
            let y = yCarouselPading
            contentView.frame = CGRect(x: x, y: y, width: containerWidth - 2*xCarouselPading, height: containerHeight-2*yCarouselPading)
        }
    }
    
    public func AlinRight(){
        currentSide = .Right
        if autoLayout{
            headAnchor.constant = (xCarouselPading + containerWidth)
            trailAnchor.constant = -xCarouselPading + containerWidth
        }else{
            let x = xCarouselPading + containerWidth
            let y = yCarouselPading
            contentView.frame = CGRect(x: x, y: y, width: containerWidth - 2*xCarouselPading, height: containerHeight-2*yCarouselPading)
        }
    }
    
    public func TouchesBegan(startPoint: CGPoint){
        self.startPoint = startPoint
        translateOffet = 0
        if autoLayout{
            startHead = headAnchor.constant
            startTrail = trailAnchor.constant
        }else{
            startFrame = contentView.frame
        }
    }
    
    public func TouchesMoved(currentPoint: CGPoint)->MoveDirection{
        guard let stP = startPoint else {
            return .Center
        }
        translateOffet = currentPoint.x - stP.x
        if autoLayout{
            headAnchor.constant = translateOffet+startHead
            trailAnchor.constant = translateOffet+startTrail
            if translateOffet < 0 {
                return .Left
            }else if translateOffet > 0{
                return .Right
            }
        }else{
            if let startFrame = self.startFrame{
                contentView.frame = startFrame.offsetBy(dx: translateOffet, dy: 0)
                if translateOffet < 0 {
                    return .Left
                }else if translateOffet > 0{
                    return .Right
                }
            }
        }
        return .Center
    }
    
    func animateToLeft(duration: TimeInterval){
        UIView.animate(withDuration: duration, animations: {
            self.AlinLeft()
            self.container.layoutIfNeeded()
        }, completion: {result in
            self.currentSide = .Left
            self.delegate.TimerSwitch(enable: true)
            //print("Go to Left")
        })
    }
    
    func animateToRight(duration: TimeInterval){
        UIView.animate(withDuration: duration, animations: {
            self.AlinRight()
            self.container.layoutIfNeeded()
        }, completion: {result in
            self.currentSide = .Right
            self.delegate.TimerSwitch(enable: true)
            //print("Goto Right")
        })
    }
    
    func animateToCenter(duration: TimeInterval){
        UIView.animate(withDuration: duration, animations: {
            self.AlinCenter()
            self.container.layoutIfNeeded()
        }, completion: {result in
            self.currentSide = .Center
            self.delegate.TimerSwitch(enable: true)
            //print("Go to Center")
        })
    }
    
    private func getCorrectDuration(_ dur:Double) -> Double{
        return min(dur, maxTimeEplase)
    }
    
    public func EndTouched(direction: MoveDirection, timeEplase: Double, mainDuration: Double) -> (MoveDirection, Double){
        if startPoint == nil && startFrame == nil{
            return (currentSide, 0)
        }
        startPoint = nil
        startFrame = nil
        if timeEplase  == 0{
            print("you touch too fast!!!!!!!!!!")
            return (currentSide, 0)
        }
        
        if currentSide == .Center{
            let speed = Double(abs(translateOffet))/timeEplase
            print("speed: \(speed)")
            if translateOffet > containerWidth/2 || (translateOffet>0 && speed > goNextSpeed){
                let dur = Double(containerWidth - translateOffet)/speed
                let interval = getCorrectDuration(dur)
                animateToRight(duration: TimeInterval(interval))
                return (.Right,interval)
            }else if translateOffet < -containerWidth/2 || (translateOffet<0 && speed > goNextSpeed){
                let dur = Double(containerWidth + translateOffet)/speed
                let interval = getCorrectDuration(dur)
                animateToLeft(duration: TimeInterval(interval))
                return (.Left, interval)
            }
            let correctTime = getCorrectDuration(timeEplase)
            animateToCenter(duration: TimeInterval(correctTime))
            return (.Center, correctTime)
        }else if currentSide == .Left && mainDuration != 0{
            if direction == .Right{
                animateToCenter(duration: TimeInterval(mainDuration))
            }else {
                animateToLeft(duration: TimeInterval(mainDuration))
            }
        }else if currentSide ==  .Right && mainDuration != 0{
            if direction == .Left{
                animateToCenter(duration: TimeInterval(mainDuration))
            }else{
                animateToRight(duration: TimeInterval(mainDuration))
            }
        }
        translateOffet = 0
        return (.Center, 0)
    }
}

protocol ScrollStateDelegate: AnyObject {
    func ChangeScrollState(enable: Bool)
}

protocol TimerSwitch {
    func TimerSwitch(enable: Bool)
}

final class Carousel: UIView, TimerSwitch {
    
    let usingCustomeRecognizer = true
    
    var delegate: ScrollStateDelegate?
    
    let indexSpacing:CGFloat = 3
    let indexHeight:CGFloat = 1.2
    let indexWidth:CGFloat = 12
    let indexContainerPading:CGFloat = 15
    
    static let indexDeactiveAlpha:CGFloat = 0.5
    let indexActiveColor:UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: indexDeactiveAlpha)
    let indexActiveAlpha:CGFloat = 0.9
    
    var currentIndex = -1
    var folowIndex = -1
    
    var currentDirection: CarouselItem.MoveDirection = .Center
    
    var listCrs = [CarouselItem]()
    
    var goNext: Bool = false
    
    lazy var indexPreview:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .equalCentering // .fillEqually .fillProportionally .equalSpacing .equalCentering
        //stackView.backgroundColor = .yellow
        stackView.spacing = indexSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var observer: NSKeyValueObservation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init from frame")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init from code")
        setupView()
    }
    
    public func LoadItem(img: String){
        if currentIndex == -1{
            currentIndex = 0
        }
        let item = CarouselItem(container:self, img: img, timerSwitch: self)
        listCrs.append(item)
        addSubview(item.GetUIImage())
        if listCrs.count == 1{
            item.InitAlinCenter()
        }else{
            item.InitAlinRight()
        }
        addIndex()
    }
    
    private func setupView(){
        
        observer = self.layer.observe(\.bounds){ object,_ in
            for item in self.listCrs {
                item.ResetView(containerWidth: object.bounds.size.width, containerHeight: object.bounds.size.height)
            }
        }
        
        //add carousel-index
        
        addSubview(indexPreview)
        indexPreview.layer.zPosition = 1000
        indexPreview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indexPreview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -indexContainerPading).isActive = true
        
        //
        
        backgroundColor = .systemGray4
        
        for item in listCrs {
            addSubview(item.GetUIImage())
        }
        
        setupLayout()
        
        if usingCustomeRecognizer{
            print("Using default recognizer!")
            let gesture = MyRecognizer(target: self, action:  #selector(self.checkAction))
            gesture.setMainView(mainView: self)
            self.addGestureRecognizer(gesture)
        }
        
        createTimer()
        
        print("done setup layout!")
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        if event?.touches(for: self)?.count==1, let touch = touches.first {
            touchesBegan(startPoint: touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(touches, with: event)
        if event?.touches(for: self)?.count==1, let touch = touches.first {
            print("default-num: \(touches.count)")
            touchesMoved(currrentPoint: touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesEnded(touches, with: event)
        print("end default")
        touchesEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancel touch")
        //super.touchesCancelled(touches, with: event)
        touchesEnded()
    }
    
    
    
    
    
    // time go next
    var timer:Timer?
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode(){
        //print("go next")
        if !touching && listCrs.count > 0{
            if goNext{
                goNext = false
                return
            }
            let currentNext = getNext()
            if listCrs[currentNext].currentSide == .Left {
                listCrs[currentNext].AlinRight()
                layoutIfNeeded()
            }
            
            listCrs[currentIndex].animateToLeft(duration: TimeInterval(Double(0.2)))
            listCrs[currentNext].animateToCenter(duration: TimeInterval(Double(0.2)))
            activeIndex(oldIndex: currentIndex, newIndex: currentNext)
            currentIndex = currentNext
            delegate?.ChangeScrollState(enable: true)
        }
    }
    
    func TimerSwitch(enable: Bool){
        goNext = true
        touching = false
        finishedAnimation=true
    }
    
    
    func addIndex(){
        let textLabel = UIView()
        textLabel.backgroundColor = indexActiveColor
        textLabel.widthAnchor.constraint(equalToConstant: indexWidth).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: indexHeight).isActive = true
        if currentIndex == indexPreview.subviews.count{
            textLabel.backgroundColor = textLabel.backgroundColor?.withAlphaComponent(indexActiveAlpha)
        }
        indexPreview.addArrangedSubview(textLabel)
    }
    
    func activeIndex(oldIndex:Int, newIndex:Int){
        for (index, item) in indexPreview.subviews.enumerated(){
            if index == oldIndex{
                item.backgroundColor = item.backgroundColor?.withAlphaComponent(Carousel.indexDeactiveAlpha)
            }else if index == newIndex{
                item.backgroundColor = item.backgroundColor?.withAlphaComponent(indexActiveAlpha)
            }
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("touch")
    }
    
    private func setupLayout(){
        for (index, item) in listCrs.enumerated() {
            if index == currentIndex {
                item.InitAlinCenter()
            }else{
                item.InitAlinRight()
            }
        }
    }
    
    private func configView(){
        guard let view  = self.LoadFileFromNib(nibName: "Carousel")
        else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func getNext() -> Int {
        return (currentIndex+1)%listCrs.count
    }
    
    func getPre() -> Int {
        if currentIndex <= 0 {
            return listCrs.count-1
        }
        return currentIndex-1
    }
    
    var startPoint: CGPoint = CGPoint()
    var startTime =  DispatchTime.now()
    var endTime = DispatchTime.now()
    
    var touching = false
    var finishedAnimation = true
    
    public func touchesBegan(startPoint: CGPoint){
        touching = true
        if finishedAnimation {
            delegate?.ChangeScrollState(enable: false)
            print("Began")
            if currentIndex != -1{
                self.startPoint = startPoint
                startTime = DispatchTime.now()
                listCrs[currentIndex].TouchesBegan(startPoint: startPoint)
            }
        }
    }
    
    public func touchesMoved(currrentPoint: CGPoint){
        print("Moved")
        if currentIndex != -1 && finishedAnimation {
            let direction = listCrs[currentIndex].TouchesMoved(currentPoint: currrentPoint)
            if direction != currentDirection {
                currentDirection = direction
                if currentDirection == .Left{
                    folowIndex = getNext()
                    listCrs[folowIndex].AlinRight()
                    listCrs[folowIndex].TouchesBegan(startPoint: listCrs[currentIndex].startPoint!)
                }else if currentDirection == .Right{
                    folowIndex = getPre()
                    listCrs[folowIndex].AlinLeft()
                    listCrs[folowIndex].TouchesBegan(startPoint: listCrs[currentIndex].startPoint!)
                }
            }else{
                if folowIndex != -1{
                    _ = listCrs[folowIndex].TouchesMoved(currentPoint: currrentPoint)
                }
            }
            setNeedsLayout()
        }
    }
    
    public func touchesEnded(){
        print("End")
        finishedAnimation = false
        delegate?.ChangeScrollState(enable: true)
        currentDirection = .Center
        if currentIndex != -1 {
            endTime = DispatchTime.now()
            let timeElapse = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
            
            let (moveDir, mainDuration) = listCrs[currentIndex].EndTouched(direction: .Center, timeEplase: timeElapse, mainDuration: 0)
            if mainDuration == 0 {
                print("Something wrong!")
                finishedAnimation = true
                return
            }
            if folowIndex != -1 {
                _ = listCrs[folowIndex].EndTouched(direction: moveDir, timeEplase: timeElapse, mainDuration: mainDuration)
            }
            if moveDir != .Center && folowIndex != -1{
                activeIndex(oldIndex: currentIndex, newIndex: folowIndex)
                currentIndex = folowIndex
            }
        }
    }
}
