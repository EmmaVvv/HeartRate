# HeartRate
Данная репозитория описывает процесс получения данных о текущем пульсе пользователя, используя следующий механизм: пользователь прикладывает палец к задней камере айфона с ключенным фонариком. 

Далее, используя делегат методы AVKit фреймворка, вы собираемся получать кадры в пиксельной репрезентации (CVPixelBuffer), конвертировать их формат UIImage, c помощью которой и сможем уже получить rgb данные. 
Текущие rbg данные необходимо конвертировать в HSV формат (Hue-Saturation-Value), посколько этот формат позволяет разграничивать более специфичные структуры (такие как, например, цвет кожи). 

Оперируя этими данными, мы в итоге выводим среднее значение по количеству измнений HSV в том или ином направлении. 

---------------------------------------------------------------------------------------------------------------------------
This repository describes process of getting data of user's current heart rate by using the following mechanism: User places his finger on iPhone back camera with flashlight on. 

Then, using AVKit delegate methods, we're going to get pixel represented frames (CVPixelBuffer), convert them to UIImage format which will provide us with rgb values for the current frame. 
We should convert these rgb value into HSV format (Hue-Saturation-Value), as it helps us detect more specific structures and objects (such as skin color, etc.)

Managing these properties, we're getting average values for HSV changes based on one or another direction.
