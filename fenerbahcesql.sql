
-- Name ve Surname kolonlarýný birlestirerek FullName adýnda
-- yeni bir kolon olusturuldu
SELECT 
Name + ' ' + ISNULL(Surname,'') AS FullName
FROM OyuncuBilgisi

ALTER TABLE OyuncuBilgisi
ADD FullName Varchar(50);

UPDATE OyuncuBilgisi
SET FullName = 
Name + ' ' + ISNULL(Surname,'')
FROM OyuncuBilgisi


--Verisetinde bulunan Birthdate kolonuyla gunumuz tarihinin farkini alarak
--Age kolonu olusturuldu
SELECT FullName,Birthdate, 
DATEDIFF(YEAR,Birthdate,GETDATE()) AS Age
FROM OyuncuBilgisi

ALTER TABLE OyuncuBilgisi
ADD Age INT;

UPDATE OyuncuBilgisi
SET Age = DATEDIFF(YEAR,Birthdate,GETDATE())
FROM OyuncuBilgisi


--Daha onceden olusturmus oldugumuz Age kolonunu baz alarak 
--genc,orta yaslý ve yaslý seklinde gruplama yapýldý
SELECT FullName,Age,
CASE
	WHEN Age <= 23 THEN 'Genç'
	WHEN Age BETWEEN 23 AND 29 THEN 'Orta Yaþlý'
	WHEN Age >29 THEN 'Yaþlý'
END YasGrup
FROM OyuncuBilgisi

ALTER TABLE OyuncuBilgisi
ADD AgeGroup VARCHAR(10);

UPDATE OyuncuBilgisi
SET AgeGroup = 
CASE
	WHEN Age <= 23 THEN 'Genç'
	WHEN Age BETWEEN 23 AND 29 THEN 'Orta Yaþlý'
	WHEN Age >29 THEN 'Yaþlý'
END 
FROM OyuncuBilgisi

--Jayden Oosterwolde ve Ferdi Kadioglunun contract expires bilgisi yanlýs yazýlmýstý
--duzeltildi
UPDATE OyuncuBilgisi
SET ContractExpires = '2027-06-30'
WHERE Name='Jayden'

UPDATE OyuncuBilgisi
SET ContractExpires = '2026-06-30'
WHERE Name='Ferdi'

--Oyuncularin Fenerbahce takimindaki kontrat sureleri
SELECT FullName,[Join],ContractExpires,
DATEDIFF(YEAR,[Join],ContractExpires) AS ContractDuration
FROM OyuncuBilgisi 


--Fenerbahce takimindaki oyuncularin uluslari
SELECT Nation,COUNT(Nation) AS NationCount From OyuncuBilgisi
GROUP BY Nation
ORDER BY NationCount DESC

--Oyuncularin boylarinin ortalamasi bir degiskene atandi ardindan
--oyuncularin boylarinin ortalamaya göre durumu degerlendirildi
DECLARE @AvgHeight DECIMAL(10,2);

SELECT @AvgHeight = AVG(CAST(Height AS DECIMAL(10,2)))
FROM OyuncuBilgisi

SELECT FullName,Height,
CASE
    WHEN Height > @AvgHeight THEN 'Ortalamadan uzun'
    WHEN Height < @AvgHeight THEN 'Ortalamadan kýsa'
END AS HeightComparisonResult
FROM 
OyuncuBilgisi


--Oyuncularin kilolarinin ortalamasi bir degiskene atandi ardindan
--oyuncularin kilolarinin ortalamaya göre durumu degerlendirildi
DECLARE @AVGWeight DECIMAL(10,2);

SELECT @AVGWeight = AVG(CAST(Weight AS DECIMAL (10,2))) 
FROM OyuncuBilgisi

SELECT FullName,Weight,@AVGWeight AS AvgWeight,
CASE
	WHEN Weight > @AVGWeight THEN 'Ortalamadan Yüksek'
	WHEN Weight < @AVGWeight THEN 'Ortalamadan Az'
END WeightComparisonResult
FROM OyuncuBilgisi


--Takimdaki kullanilan ayak sayilari
SELECT Foot,COUNT(Foot) 
FROM OyuncuBilgisi
GROUP BY Foot

--Fenerbahce takiminin toplam brut ve net maaslar
SELECT 
    SUM(GrossSalary_P_y) AS GrossSalary,
    SUM(NetSalary_P_y) AS NetSalary
FROM MaasBilgisi

--Oyuncularin maaslarinin ayda ve haftada ne kadar olduklarý hesaplandý
SELECT Name,
	SUM(GrossSalary_P_y)/12 AS GrossSalaryPerMonth,
	(SUM(GrossSalary_P_y)/12) / 4 GrossSalaryWeek,
	SUM(NetSalary_P_y)/12 AS NetSalaryPerMonth,
	(SUM(NetSalary_P_y)/12) / 4 NetSalaryWeek
FROM MaasBilgisi
GROUP BY Name
ORDER BY GrossSalaryPerMonth DESC

--Oyuncular icerisinde brut maasý en yuksek ve en dusuk olanlar 
SELECT TOP 1 MAX(GrossSalary_P_y) AS MaxGrossSalary,
O.FullName
FROM MaasBilgisi MB
JOIN OyuncuBilgisi O ON O.PlayerID=MB.PlayerID
GROUP BY O.FullName
ORDER BY MaxGrossSalary DESC

SELECT TOP 1 MIN(GrossSalary_P_y) AS MinGrossSalary,
O.FullName
FROM MaasBilgisi MB
JOIN OyuncuBilgisi O ON O.PlayerID=MB.PlayerID
GROUP BY O.FullName
ORDER BY MinGrossSalary 



--Oyuncularin kontrat sureleri boyunca kazanacaklari net maas tutarlarý
--contract duration carpi netsalary_p_y islemi ile bulundu
SELECT O.FullName,O.[Join],O.ContractExpires,
DATEDIFF(YEAR,O.[Join],O.ContractExpires) AS ContractDuration,MB.NetSalary_P_y,
DATEDIFF(YEAR,O.[Join],O.ContractExpires)*MB.NetSalary_P_y
FROM MaasBilgisi MB 
JOIN OyuncuBilgisi O ON O.PlayerID=MB.PlayerID


--Oyuncularin kontrat sureleri boyunca kazanacaklari net maas tutarlarini metin ile yazildi
--contract duration carpi netsalary_p_y islemi ile bulundu
SELECT O.FullName,
DATEDIFF(YEAR, O.[Join], O.ContractExpires) AS ContractDuration,
MB.NetSalary_P_y,
CASE 
    WHEN DATEDIFF(YEAR, O.[Join], O.ContractExpires) * MB.NetSalary_P_y / 1000000 > 0 THEN
        CONVERT(varchar, DATEDIFF(YEAR, O.[Join], O.ContractExpires) * MB.NetSalary_P_y / 1000000) + ' milyon '
    ELSE ''
END +
CASE 
    WHEN (DATEDIFF(YEAR, O.[Join], O.ContractExpires) * MB.NetSalary_P_y % 1000000) / 1000 > 0 THEN
        CONVERT(varchar, (DATEDIFF(YEAR, O.[Join], O.ContractExpires) * MB.NetSalary_P_y % 1000000) / 1000) + ' bin euro kazanacak'
    ELSE 'euro kazanacak'
END AS NetSalaryTotal
FROM MaasBilgisi MB 
JOIN OyuncuBilgisi O ON O.PlayerID = MB.PlayerID

--Fenerbahce futbol takimi kadro degeri
SELECT SUM([31_12_2023]) AS SumPrice2023 
FROM PiyasaDegeri 


--Fenerbahce takimindaki oyuncularin 2023 yilinda pozisyonlara gore degerlerinin toplami
SELECT O.Position, SUM([31_12_2023]) AS SumPrice2023 , COUNT(O.Position) CountPositon
FROM PiyasaDegeri PD
JOIN OyuncuBilgisi O ON O.PlayerID = PD.PlayerID
GROUP BY O.Position
ORDER BY SumPrice2023 DESC


--Fenerbahce takimindaki oyuncularin 2023 yilinda yas gruplarina gore degerlerinin toplami
SELECT O.AgeGroup, AVG([31_12_2023]) AS AVGPrice2023 , COUNT(O.AgeGroup) CountAgeGroup
FROM PiyasaDegeri PD
JOIN OyuncuBilgisi O ON O.PlayerID = PD.PlayerID
GROUP BY O.AgeGroup
ORDER BY AVGPrice2023 DESC


--Oyuncularin mac kadrolarinda oynama durumlari
SELECT Name + ' ' + 
CASE 
    WHEN Surname IS NOT NULL THEN Surname + ' ' 
    ELSE '' 
END + 
CASE 
    WHEN Match_Played = 0 THEN 'hiçbir maçta oynamamýþtýr'
    WHEN Match_Played = Starts THEN 'oynadýðý ' + CONVERT(nvarchar(10), Match_Played) + ' maça da ilk 11 olarak baþlamýþtýr'
    ELSE 'çýktýðý ' + CONVERT(nvarchar(10), Match_Played) + ' maçýn ' + CONVERT(nvarchar(10), Starts) + ' (ne/na) ilk 11 olarak baþlamýþtýr'
END
FROM Performans


--Fenerbahce takiminin toplam gol ve asist sayilari
SELECT SUM(Goals) AS GoalsCount,SUM(Asists) AS AsistsCount
FROM Performans


--Mevkilere gore gol ve asist sayilari
SELECT O.Position,SUM(Goals) AS GoalsCount,SUM(Asists) AS AsistsCount, COUNT(O.Position) AS PositionCount
FROM Performans P
JOIN OyuncuBilgisi O ON P.PlayerID=O.PlayerID
GROUP BY O.Position


--Futbolcularin kac 90 dakika oynadigi ve 
--oynadiklari 90 dakika basýna attiklari gol sayilari
SELECT Name,Minutes,
CASE 
	WHEN Minutes <> 0 THEN CAST((Minutes/90.0) AS DECIMAL(10, 2)) 
	ELSE 0 END AS [90sPlayed],
CASE 
	WHEN Minutes <> 0 THEN CAST(Goals/(Minutes/90.0) AS DECIMAL(10, 2)) 
	ELSE 0 END AS Goals_Per_90
FROM Performans


--Futbolcularin kac 90 dakika oynadigi ve 
--oynadiklari 90 dakika basýna attiklari gol sayilarinin tabloya kaydedilmesi
ALTER TABLE Performans
ADD [90sPlayed] DECIMAL(10, 2);

ALTER TABLE Performans
ADD Goals_Per90 DECIMAL(10, 2);


UPDATE Performans
SET [90sPlayed] =
CASE 
	WHEN Minutes <> 0 THEN CAST((Minutes/90.0) AS DECIMAL(10, 2)) 
	ELSE 0 END FROM Performans

UPDATE Performans
SET Goals_Per90 =
CASE 
	WHEN Minutes <> 0 THEN CAST(Goals/(Minutes/90.0) AS DECIMAL(10, 2)) 
	ELSE 0 END
FROM Performans


--Futbolcularin mac basýna beklenenden fazla veya az gol atma karsilastirmasi
SELECT Name,Goals,xG_per90,Goals_Per90,
CASE
	WHEN Goals_Per90 > xG_per90 THEN 'Maç baþýna beklenenden fazla gol atmýþtýr'
	ELSE 'Maç baþýna beklenenden az gol atmýþtýr'
END
FROM Performans


--Takimdaki oyuncularin mevkilerine gore basarili dribling ortalamalari
SELECT Position,AVG(P.[DribbleSuccess_per90(%)]) AS AVGDribbleSuccess_per90
FROM Performans P
JOIN OyuncuBilgisi O ON O.PlayerID = P.PlayerID
GROUP BY O.Position
ORDER BY AVGDribbleSuccess_per90 DESC


--Futbolcularin bazi bilgilerini gorebilmek icin ufak bir
--Stored Procedure olusturuldu
CREATE PROC SP_GetPlayerInfo
@Name AS VARCHAR(50)
AS
BEGIN
SELECT O.FullName,O.Nation, O.Position,O.Age,P.[31_12_2023],M.GrossSalary_P_y 
FROM OyuncuBilgisi O
JOIN MaasBilgisi M ON M.PlayerID = O.PlayerID
JOIN PiyasaDegeri P ON P.PlayerID = O.PlayerID
WHERE O.Name = @Name
END

EXEC SP_GetPlayerInfo
@Name='Edin'



