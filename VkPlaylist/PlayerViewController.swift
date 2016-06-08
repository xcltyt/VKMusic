//
//  PlayerViewController.swift
//  VkPlaylist
//
//  Created by Илья Халяпин on 05.06.16.
//  Copyright © 2016 Ilya Khalyapin. All rights reserved.
//

import UIKit

/// Контроллер с полноэкранным плеером
class PlayerViewController: UIViewController {
    
    /// Основной цвет приложения
    let tintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).tintColor
    /// Цвет элементов управления
    let controlColor = UIColor(red: 0.28, green: 0.29, blue: 0.29, alpha: 1)
    

    /// Обложка аудиозаписи на заднем фоне
    @IBOutlet weak var backgroundArtworkImageView: UIImageView!
    
    /// Область для закрытия контроллера
    @IBOutlet weak var closeAreaButton: UIButton!
    /// Элемент содержащий кнопку "Закрыть"
    @IBOutlet weak var closeView: UIView!
    /// Элемент содержащий размытый задний фон для кнопки "Закрыть"
    @IBOutlet weak var closeButtonBackgroundBlurEffectView: UIVisualEffectView!
    /// Кнопка "Закрыть"
    @IBOutlet weak var closeButton: UIButton!
    
    /// Обложка альбома
    @IBOutlet weak var artworkImageView: UIImageView!
    /// Кнопка над обложкой альбома
    @IBOutlet weak var artworkButton: UIButton!
    
    /// Элемент содержащий размытый фон и слова аудиозаписи
    @IBOutlet weak var lyricsView: UIView!
    /// Элемент с эффектом размытия для заднего фона элемента с текстом аудиозаписи
    @IBOutlet weak var lyricsBackgroundBlurEffectView: UIVisualEffectView!
    /// Элемент с текстом аудиозаписи
    @IBOutlet weak var lyricsTextView: UITextView!
    
    /// Элемент в котором находятся слайдер, бар прогресса буфферизации и метки со временем
    @IBOutlet weak var sliderView: UIView!
    /// Бар с уровнем буфферизации
    @IBOutlet weak var bufferingProgressView: UIProgressView!
    /// Слайдер с аудиозаписью
    @IBOutlet weak var trackSlider: UISlider!
    /// Constraint верхнего отступа для слайдера аудиозаписи
    @IBOutlet weak var topSpaceTrackSlider: NSLayoutConstraint!
    /// Надпись "Прошедшее время от начала аудиозаписи"
    @IBOutlet weak var currentTimeLabel: UILabel!
    /// Надпись "Оставшееся время до конца аудиозаписи"
    @IBOutlet weak var leftTimeLabel: UILabel!
    
    /// Элемент в котором находятся надписи с названием аудиозаписи и именем исполнителя
    @IBOutlet weak var titleAndArtistView: UIView!
    /// Надпись "Название аудиозаписи"
    @IBOutlet weak var titleLabel: UILabel!
    /// Надпись "Имя исполнителя"
    @IBOutlet weak var artistLabel: UILabel!
    
    /// Кнопка "Скачать"
    @IBOutlet weak var downloadButton: UIButton!
    /// Кнопка "Предыдущая аудиозапись"
    @IBOutlet weak var previousTrackButton: UIButton!
    /// Кнопка "Play" или "Пауза"
    @IBOutlet weak var playOrPauseButton: UIButton!
    /// Кнопка "Следующая аудиозапись"
    @IBOutlet weak var nextTrackButton: UIButton!
    /// Кнопка "Текущий плейлист"
    @IBOutlet weak var currentPlaylistButton: UIButton!
    
    /// Элемент содержащий слайдер управления звуком
    @IBOutlet weak var volumeView: UIView!
    /// Слайдер с управлением звука
    @IBOutlet weak var volumeSlider: UISlider!
    /// Иконка "Минимальный звук"
    @IBOutlet weak var muteVolumeImageView: UIImageView!
    /// Иконка "Максимальный звук"
    @IBOutlet weak var loudlyVolumeImageView: UIImageView!
    
    /// Элемент содержащий кнопку "Отобразить в статусе"
    @IBOutlet weak var shareToStatusView: UIView!
    /// Кнопка "Отобразить в статусе"
    @IBOutlet weak var shareToStatusButton: UIButton!
    /// Элемент содержащий кнопку "Отобразить слова аудиозаписи"
    @IBOutlet weak var lyricsButtonView: UIView!
    /// Кнопка "Отобразить слова аудиозаписи"
    @IBOutlet weak var lyricsButton: UIButton!
    /// Элемент содержащий кнопку "Перемешать"
    @IBOutlet weak var shuffleView: UIView!
    /// Кнопка "Перемешать"
    @IBOutlet weak var shuffleButton: UIButton!
    /// Элемент содержащий кнопку "Повторить"
    @IBOutlet weak var repeatView: UIView!
    /// Кнопка "Повторить"
    @IBOutlet weak var repeatButton: UIButton!
    /// Кнопка "Еще"
    @IBOutlet weak var moreButton: UIButton!
    
    
    /// Показывать ли слова аудиозаписи
    var isShowLyrics = false
    /// Воспроизводится ли аудиозапись
    var isPlaying: Bool {
        set {
            PlayerManager.sharedInstance.isPlaying = newValue
        }
        get {
            return PlayerManager.sharedInstance.isPlaying
        }
    }
    /// Отображать ли музыку в статусе
    var isShareToStatus: Bool {
        set {
            PlayerManager.sharedInstance.isShareToStatus = newValue
        }
        get {
            return PlayerManager.sharedInstance.isShareToStatus
        }
    }
    /// Перемешать ли плейлист
    var isShuffle: Bool {
        set {
            PlayerManager.sharedInstance.isShuffle = newValue
        }
        get {
            return PlayerManager.sharedInstance.isShuffle
        }
    }
    /// Тип перемешивания
    var repeatType: PlayerManager.RepeatType {
        set {
            PlayerManager.sharedInstance.repeatType = newValue
        }
        get {
            return PlayerManager.sharedInstance.repeatType
        }
    }
    
    /// Распознатель тапов по текстовому полю
    var lyricsTapRecognizer: UITapGestureRecognizer!
    /// Иконка "Скачать"
    var downloadIcon: UIImage {
        return UIImage(named: "icon-PlayerDownload")!.tintPicto(controlColor)
    }
    /// Иконка "Предыдущая аудиозапись"
    var previousTrackIcon: UIImage {
        return UIImage(named: "icon-PlayerPreviousTrack")!.tintPicto(controlColor)
    }
    /// Иконка для кнопки "Play" / "Пауза"
    var playOrPauseIcon: UIImage {
        return UIImage(named: isPlaying ? "icon-PlayerPause" : "icon-PlayerPlay")!.tintPicto(controlColor)
    }
    /// Иконка "Следующая аудиозапись"
    var nextTrackIcon: UIImage {
        return UIImage(named: "icon-PlayerNextTrack")!.tintPicto(controlColor)
    }
    /// Иконка "Текущий плейлист"
    var currentPlaylistIcon: UIImage {
        return UIImage(named: "icon-PlayerCurrentPlaylist")!.tintPicto(controlColor)
    }
    /// Иконка для кнопки "Отобразить в статус"
    var shareToStatusIcon: UIImage {
        return UIImage(named: "icon-PlayerShareToStatus")!.tintPicto(isShareToStatus ? tintColor : controlColor)
    }
    /// Размытый задний фон для активного состояния кнопки "Отобразить в статус"
    var shareToStatusBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    /// Иконка для кнопки "Отобразить слова аудиозаписи"
    var lyricsIcon: UIImage {
        return UIImage(named: "icon-PlayerLyrics")!.tintPicto(isShowLyrics ? tintColor : controlColor)
    }
    /// Размытый задний фон для активного состояния кнопки "Отобразить слова аудиозаписи"
    var lyricsButtonBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    /// Иконка для кнопки "Перемешать"
    var shuffleIcon: UIImage {
        return UIImage(named: "icon-PlayerShuffle")!.tintPicto(isShuffle ? tintColor : controlColor)
    }
    /// Размытый задний фон для активного состояния кнопки "Перемешать"
    var shuffleBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    /// Иконка для кнопки "Повторить"
    var repeatIcon: UIImage {
        return UIImage(named: repeatType == .One ? "icon-PlayerRepeatOne" : "icon-PlayerRepeat")!.tintPicto(repeatType == .All || repeatType == .One ? tintColor : controlColor)
    }
    /// Размытый задний фон для активного состояния кнопки "Повторить"
    var repeatBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    /// Иконка для кнопки "Еще"
    var moreIcon: UIImage {
        return UIImage(named: "icon-More")!.tintPicto(controlColor)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Настройка кнопки "Закрыть"
        closeView.layer.cornerRadius = closeView.bounds.size.height / 2
        closeView.layer.masksToBounds = true
        closeButton.setImage(UIImage(named: "icon-PlayerClose")!.tintPicto(UIColor.whiteColor()), forState: .Normal)
//        closeButton.removeFromSuperview()
//        let closeButtonVibrancyEffect = UIVibrancyEffect(forBlurEffect: closeButtonBackgroundBlurEffectView.effect as! UIBlurEffect)
//        let closeButtonVibrancyEffectView = UIVisualEffectView(effect: closeButtonVibrancyEffect)
//        closeButtonVibrancyEffectView.frame = closeButtonBackgroundBlurEffectView.frame
//        closeButtonVibrancyEffectView.contentView.addSubview(closeButton)
//        closeButtonBackgroundBlurEffectView.contentView.addSubview(closeButtonVibrancyEffectView)
        
        // Инициализация распознавателя тапов по элементу с текстом аудиозаписи
        lyricsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lyricsTapped))
        lyricsTapRecognizer.delegate = self
        
        // Настройка отображения слов аудиозаписи
        lyricsView.hidden = true
        lyricsView.alpha = 0
        
        // Заполняем пустое слева от слайдера
        let leftSliderSubview = UIView(frame: CGRectMake(0, 0, 3, 2))
        leftSliderSubview.backgroundColor = (UIApplication.sharedApplication().delegate as! AppDelegate).tintColor
        sliderView.insertSubview(leftSliderSubview, belowSubview: bufferingProgressView)
        
        // Заполняем пустое справа от слайдера
        let rightSliderSubview = UIView(frame: CGRectMake(view.bounds.size.width - 3, 0, 3, 2))
        rightSliderSubview.backgroundColor = UIColor.lightGrayColor()
        sliderView.insertSubview(rightSliderSubview, belowSubview: bufferingProgressView)
        
        // Настройка бара отображающего прогресс буфферизации
        bufferingProgressView.progressTintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).tintColor.colorWithAlphaComponent(0.4)
        bufferingProgressView.trackTintColor = UIColor.lightGrayColor()
        
        // Настройка слайдера с аудиозаписью
        trackSlider.minimumTrackTintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).tintColor
        trackSlider.maximumTrackTintColor = UIColor.clearColor()
        trackSlider.setThumbImage(UIImage(named: "icon-PlayerThumbTrack")!.tintPicto(UIColor.whiteColor()), forState: .Normal)
        topSpaceTrackSlider.constant = -9
        
        // Настройка надписи с названием аудиозаписи
        titleLabel.textColor = controlColor
        
        // Настройка кнопки "Скачать"
        downloadButton.setImage(downloadIcon, forState: .Normal)
        
        // Настройка кнопки "Предыдущая аудиозапись"
        previousTrackButton.setImage(previousTrackIcon, forState: .Normal)
        
        // Настройка кнопки "Play" / "Пауза"
        playOrPauseButton.setImage(playOrPauseIcon, forState: .Normal)
        
        // Настройка кнопки "Следующая аудиозапись"
        nextTrackButton.setImage(nextTrackIcon, forState: .Normal)
        
        // Настройка кнопки "Текущий плейлист"
        currentPlaylistButton.setImage(currentPlaylistIcon, forState: .Normal)
        
        // Настройка слайдера со звуком
        volumeSlider.setThumbImage(UIImage(named: "icon-PlayerThumbVolume")!.tintPicto(UIColor.whiteColor()), forState: .Normal)
        muteVolumeImageView.image = muteVolumeImageView.image!.tintPicto(UIColor(red: 115 / 255, green: 116 / 255, blue: 117 / 255, alpha: 1))
        loudlyVolumeImageView.image = loudlyVolumeImageView.image!.tintPicto(UIColor(red: 115 / 255, green: 116 / 255, blue: 117 / 255, alpha: 1))
        
        // Настройка кнопки "Отобразить в статусе"
        shareToStatusBlurEffectView.frame = shareToStatusView.bounds
        shareToStatusView.layer.cornerRadius = 3
        shareToStatusView.layer.masksToBounds = true
        configureShareToStatusButton()
        
        // Настройка кнопки "Отобразить слова аудиозаписи"
        lyricsButtonBlurEffectView.frame = lyricsButtonView.bounds
        lyricsButtonView.layer.cornerRadius = 3
        lyricsButtonView.layer.masksToBounds = true
        configureLyricsButton()
        
        // Настройка кнопки "Перемешать"
        shuffleBlurEffectView.frame = shuffleView.bounds
        shuffleView.layer.cornerRadius = 3
        shuffleView.layer.masksToBounds = true
        configureShuffleButton()
        
        // Настройка кнопки "Повторить"
        repeatBlurEffectView.frame = repeatView.bounds
        repeatView.layer.cornerRadius = 3
        repeatView.layer.masksToBounds = true
        configureRepeatButton()
        
        // Настройка кнопки "Еще"
        moreButton.setImage(moreIcon, forState: .Normal)
    }
    
    
    // MARK: Помощники
    
    /// По элементу со словами аудиозаписи был тап
    func lyricsTapped() {
        isShowLyrics = !isShowLyrics
        configureLyricsAppear()
        configureLyricsButton()
    }
    
    /// Настройка отображения слов аудиозаписи
    func configureLyricsAppear() {
        if isShowLyrics {
            artworkButton.enabled = false
            lyricsButton.enabled = false
            
            lyricsTextView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false) // Пролистываем текст до верха
            
            lyricsView.hidden = false
            UIView.animateWithDuration(0.5, animations: {
                self.lyricsView.alpha = 1
            }, completion: { _ in
                self.lyricsTextView.addGestureRecognizer(self.lyricsTapRecognizer)
                self.lyricsButton.enabled = true
            })
        } else {
            lyricsTextView.removeGestureRecognizer(lyricsTapRecognizer)
            lyricsButton.enabled = false
            
            UIView.animateWithDuration(0.5, animations: {
                self.lyricsView.alpha = 0
            }, completion: { _ in
                self.lyricsView.hidden = true
                
                self.artworkButton.enabled = true
                self.lyricsButton.enabled = true
            })
        }
    }
    
    /// Настройка кнопки "Отобразить в статусе" для текущего состояния
    func configureShareToStatusButton() {
        if isShareToStatus {
            shareToStatusView.insertSubview(shareToStatusBlurEffectView, belowSubview: shareToStatusButton)
        } else {
            shareToStatusBlurEffectView.removeFromSuperview()
        }
        
        shareToStatusButton.setImage(shareToStatusIcon, forState: .Normal)
    }
    
    /// Настройка кнопки "Отобразить слова аудиозаписи"
    func configureLyricsButton() {
        if isShowLyrics {
            lyricsButtonView.insertSubview(lyricsButtonBlurEffectView, belowSubview: lyricsButton)
        } else {
            lyricsButtonBlurEffectView.removeFromSuperview()
        }
        
        lyricsButton.setImage(lyricsIcon, forState: .Normal)
    }
    
    /// Настройка кнопки "Перемешать" для текущего состояния
    func configureShuffleButton() {
        if isShuffle {
            shuffleView.insertSubview(shuffleBlurEffectView, belowSubview: shuffleButton)
        } else {
            shuffleBlurEffectView.removeFromSuperview()
        }
        
        shuffleButton.setImage(shuffleIcon, forState: .Normal)
    }
    
    /// Переключение типа повторения
    func nextRepeatType() {
        switch repeatType {
        case .No:
            repeatType = .All
        case .All:
            repeatType = .One
        case .One:
            repeatType = .No
        }
    }
    
    /// Настройка кнопки "Повторить"
    func configureRepeatButton() {
        switch repeatType {
        case .No:
            repeatBlurEffectView.removeFromSuperview()
        case .All:
            repeatView.insertSubview(repeatBlurEffectView, belowSubview: repeatButton)
        case .One:
            repeatView.insertSubview(repeatBlurEffectView, belowSubview: repeatButton)
        }
        
        repeatButton.setImage(repeatIcon, forState: .Normal)
    }
    
    
    // MARK: Кнопки контроллера
    
    /// Кнопка "Закрыть" была нажата
    @IBAction func closeButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// По кнопке над обложкой был тап
    @IBAction func artworkTapped(sender: UIButton) {
        isShowLyrics = !isShowLyrics
        configureLyricsAppear()
        configureLyricsButton()
    }
    
    /// Кнопка "Скачать" была нажата
    @IBAction func downloadButtonTapped(sender: UIButton) {
        downloadButton.enabled = false
    }
    
    /// Кнопка "Play" или "Пауза" была нажата
    @IBAction func playOrPauseButtonTapped(sender: UIButton) {
        isPlaying = !isPlaying
        playOrPauseButton.setImage(playOrPauseIcon, forState: .Normal)
    }
    
    /// Кнопка "Отобразить в статусе" была нажата
    @IBAction func shareToStatusButtonTapped(sender: UIButton) {
        if isShareToStatus {
            isShareToStatus = false
            configureShareToStatusButton()
        } else {
            let alertController = UIAlertController(title: nil, message: "Проигрываемая музыка будет транслироваться в Ваш статус на сайте vk.com!", preferredStyle: .ActionSheet)
            
            let continueAction = UIAlertAction(title: "Продолжить", style: .Default) { _ in
                self.isShareToStatus = true
                self.configureShareToStatusButton()
            }
            alertController.addAction(continueAction)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    /// Кнопка "Отобразить слова аудиозаписи" была нажата
    @IBAction func lyricsButtonTapped(sender: UIButton) {
        isShowLyrics = !isShowLyrics
        configureLyricsAppear()
        configureLyricsButton()
    }
    
    /// Кнопка "Перемешать" была нажата
    @IBAction func shuffleButtonTapped(sender: UIButton) {
        isShuffle = !isShuffle
        configureShuffleButton()
    }
    
    /// Кнопка "Повторить" была нажата
    @IBAction func repeatButtonTapped(sender: UIButton) {
        nextRepeatType()
        configureRepeatButton()
    }
    
    /// Кнопка "Еще" была нажата
    @IBAction func moreButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let addToPlaylistOrAlbumAction = UIAlertAction(title: "Добавить в плейлист", style: .Default, handler: nil)
        alertController.addAction(addToPlaylistOrAlbumAction)
        
        let editArtwork = UIAlertAction(title: "Изменить обложку", style: .Default, handler: nil)
        alertController.addAction(editArtwork)
        
        let removeAction = UIAlertAction(title: "Удалить", style: .Destructive, handler: nil)
        alertController.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}


// MARK: UIGestureRecognizerDelegate

extension PlayerViewController: UIGestureRecognizerDelegate {
    
    // Спрашивает делегат позволения если два распознавателя жестов хотят распознавать жесты одновременно
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
