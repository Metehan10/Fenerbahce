# Fenerbahce
Bu çalışmada Fenerbahçe Futbol Takımı TSL 23-24 Sezonu 20.Haftaya kadar oluşan istatistiklerinin analizi yapılmıştır.

--------------------------------------------------------------------------------------
Futbolcuların verileri:
* transfermarkt.com

* fotmob.com
  
* capology.com
  
internet adreslerinden alınıp elle excel ortamına aktarılmıştır.

--------------------------------------------------------------------------------------
Excel ortamında oluşturulan datasetler Oyuncu Bilgisi, Maaş Bilgisi, Piyasa Değeri, Performans ve Resim başlıkları altında beşe bölünmüştür.
* Oyuncu Bilgisi tablosunda: PlayerID, Name, Surname, Birthdate, Height, Weight, Nation, Position, Foot, ShirtNumber, Join, ContractExpires sütunları yer almaktadır.
* Maaş Bilgisi tablosunda: PlayerID, Name, Surname, GrossSalary_P/y, NetSalary_P/y sütunları yer almaktadır.
* Piyasa Değeri tablosunda: PlayerID, Name, Surname, 31.12.2020, 31.12.2021, 31.12.2022, 31.12.2023, HighestValueMarket sütunları yer almaktadır. 
* Performans tablosunda: PlayerID, Name, Surname, Match_Played, Starts, Minutes, Goals, Asists, xG_per90, Shots_per90, ShotsOnTarget_per90, SuccessfulPasses_per90, PassAccuracy_per90(%), AccurateLongBalls_per90, LongBallAccuracy_per90(%), ChancesCreated_per90, SuccessfulDribbles_per90, DribbleSuccess_per90(%), TouchesInOppositionBox_per90, TacklesWon_per90, DuelsWon_per90, AerialDuelsWon_per90 sütunları yer almaktadır.
* Resim tablosunda: PlayerID,Name, Surname, ImageURL sütunları yer almaktadır.
--------------------------------------------------------------------------------------
Excelde tabloları oluşturduktan sonra birtakım analizler yapmak için datasetler MSSQL ortamına import edilmiştir.
MSSQL'de Futbolcuların:
* Haftalık kazancı ne kadar?
* Hangi ülkeden kaç oyuncu var?
* Sözleşme süreleri boyunca ne kadar kazanacaklar?
* 2023 yılındaki değerlerinin mevkilerine göre toplamının kaç olduğu
* 20.Haftaya kadar kaç maç oynadığı ve bunun kaçı ilk 11 olduğunun
* Oynadıkları 90 dakika başına attıkları gol sayıları
  
gibi 30'a yakın farklı analiz işlemi yapılmıştır.

---------------------------------------------------------------------------------------
MSSQL'de analiz yaptıktan sonra bir dashboard oluşturulması için MSSQL'den Power BI programına aktarılmıştır.
Power BI'da oluşturulan dashboard dört farklı sayfadan oluşmaktadır:
* Futbolcu Bilgisi
* Futbolcu İstatistik
* Takım İstatistik
* Takım Performans



