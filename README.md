# Cinema

## Цель: 

Создать агрегатор фильмов с разными жанрами, рейтингами, подробным описнием фильмов и прочее.

- документация [здесь](https://www.themoviedb.org/documentation/api)

- макет для верстки ленты адаптировал с Figma

![IMG_0209](https://user-images.githubusercontent.com/64494962/137786642-510603a9-833d-466b-8453-1e772b1d9d03.gif)

## Что использовал:
• Compositional Layout для отображения ячейки

• верстка с Auto Layout anchors

• Для работы с сетью сделал class MovieService (singleton pattern)

> сейчас Сервис закрыт протоколом, но в будущем будет инжект с 
```swift
class MovieViewModel {

    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol) {
     self.movieService = movieService
    }

    ...

}
```
> чтобы можно в будущем было подменить этот объект и написать тесты на MovieViewModel

• для создание нужного url использовал URLQueryItem + Endpoint

• открыл URLSession, где данные приходят в background потоке 

• В методе fetchAllMovies загрузку из 4-х источников с помощью [DispatchGroup](https://developer.apple.com/documentation/dispatch/dispatchgroup) 
 
• Для перехода на новый экран использовал метод делегата [didSelectItemAt](https://developer.apple.com/documentation/uikit/uicollectionviewdelegate/1618032-collectionview)
 
• для переиспользования ячеек использовал метод [dequeueReusableCell](https://developer.apple.com/documentation/uikit/uicollectionview/1618063-dequeuereusablecell)
 
• кеширование и анимация изображений с помощью [Kingfisher](https://github.com/onevcat/Kingfisher) 

• в методе [prepareForReuse](https://developer.apple.com/documentation/uikit/uitableviewcell/1623223-prepareforreuse) у ячеек добавил отмену загрузки картинок, иначе если быстро скролить может большое кол-во тасок на загрузку картинок создаться, хотя мы уже проскролили далеко и они нам не нужны:

```swift
override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
```


  
![photo_2021-10-18 21 53 19](https://user-images.githubusercontent.com/64494962/137789964-1d7108f8-9aa9-4f8a-9eba-81c7dc6358ee.jpeg)
