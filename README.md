# Cinema

## Цель: 

Создать приложение для агрегатор фильмов, с разными жанрами, рейтингами, подробным описнием фильмов и прочее.

- документация [здесь](https://www.themoviedb.org/documentation/api)

- макет для верстки ленты адаптировал с Figma

## Что использовал:
• Compositional Layout для отображения ячейки

• верстка с Auto Layout anchors

• Для работы с сетью сделал class MovieService (singleton pattern)

в будущем будет инжект с 
```
class MovieViewModel {

    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol) {
     self.movieService = movieService
    }

    ...

}
```

• для создание нужного url использовал URLQueryItem + Endpoint

• открыл URLSession, где данные приходят в background потоке
 
• инициализировал init в структурах (Codable) для того, чтобы избежать nil при декодировании 

• Для прокрутки ленты (infinite scroll/ pagination) использовал метод делегата willDisplay
 
• для переиспользования ячеек использовал метод dequeueReusableCell
  
• обновлял ячейки с помощью reloadData, потому что это наиболее простой способ
 
• обработка касаний с помощью UITapGestureRecognizer и далее передавал событие ViewController
 
• все анимирование "распахивания" картинок вынес в отдельную функцию. Повторное касание уничтожает subView по очереди. Для blurEffect использовал autoresizingMask

## Compositional Layout
  
![IMG_0209](https://user-images.githubusercontent.com/64494962/137786642-510603a9-833d-466b-8453-1e772b1d9d03.gif)

  
![IMG_0205](https://user-images.githubusercontent.com/64494962/137786719-600161b0-2350-481e-97be-f9049708086f.PNG)
