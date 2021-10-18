# Cinema

## Цель: 

Создать приложение для агрегатор фильмов, с разными жанрами, рейтингами, подробным описнием фильмов и прочее.

- документация [здесь](https://www.themoviedb.org/documentation/api)

- макет для верстки ленты адаптировал с Figma

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
 
• Для перехода на новый экран использовал метод делегата didSelectItemAt
 
• для переиспользования ячеек использовал метод dequeueReusableCell
 
• кеширование и анимация изображений с помощью [Kingfisher](https://github.com/onevcat/Kingfisher) 

## Compositional Layout
  
![IMG_0209](https://user-images.githubusercontent.com/64494962/137786642-510603a9-833d-466b-8453-1e772b1d9d03.gif)

  
![IMG_0205](https://user-images.githubusercontent.com/64494962/137786719-600161b0-2350-481e-97be-f9049708086f.PNG)
