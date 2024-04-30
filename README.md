Poniższy projekt opiera się na danych National Basketball Association (NBA), które jest  najważniejszą i najlepiej znaną ligią koszykówki na świecie. Została założona w 1946 roku i  składa się z 30 zespołów, z czego 29 znajduje się w Stanach Zjednoczonych, a jeden w 
Kanadzie. Zespoły są podzielone na Konferencję Wschodnią i Zachodnią, a każda z nich składa się z 15 zespołów. 

Celem poniższego projektu jest przewidzieć, ile punktów jest w stanie zdobyć konkretny gracz. 
Wykorzystane do tego zostały dane z sezonu 2017-2018.  
Każdy krok jest opisany jako komentarz przy danych linijkach w kodzie.  

Zaczynamy od importu potrzebnych paczek i importu danych ze nba.com:

Twrzoenie data frame’u:  
*Funkcja loc, przeszukuje DataFrame po indexie (w tym przypadku LeBron James)

Dalej rozdzielamy dane na treningowe i testowe. Następnie dane treningowe zostają użyte 
do naszego modelu.

Później tworzone są dwa histogramy, aby porównać liczbę punktów na mecz (PPG) dwóch 
grup graczy: tych poniżej 30 roku życia i tych, którzy ukończyli 30 lat.

Następnie dla każdej zmiennej tworzony jest histogram za pomocą funkcji plt.hist(). 
Parametr alfa steruje przezroczystością słupków, a parametr label określa etykietę 
histogramu, która będzie używany w legendzie. 
Legenda jest dodawana do wykresu za pomocą plt.legend() a etykiety osi x i y są dodawane 
odpowiednio za pomocą plt.xlabel() i plt.title(). 

Powyzszy kod tworzy pandas dataframe o nazwie „dt_df”, która ma dwie kolumny: 
„Rzeczywista” i „Przewidywana” i pokazuje porównanie między rzeczywistymi wartościami 
testowymi a przewidywanymi wartościami zmiennej docelowej (punkty na mecz), a także 
indeksem ramka danych test_df, która jest nazwą gracza. Metoda .flatten() służy do 
konwersji przewidywanych wartości z tablicy 2D na tablicę 1D.  

Wynik badania i wnioski:

Celem jest porównanie rzeczywistych i  przewidywanych wartości zmiennej docelowej w celu oceny wydajności modelu. Metoda 
round(1) służy do zaokrąglania wartości w ramce danych do jednego miejsca po przecinku.
