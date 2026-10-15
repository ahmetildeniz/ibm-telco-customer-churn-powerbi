--Genel şirket özeti (KPI Panosu)
SELECT 
	COUNT(*) AS ToplamMusteriSayisi,
	SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnMusteriSayisi,
	SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS AktifMusteriSayisi,
	ROUND(CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100,2) AS ChurnOrani_Yuzde,
	ROUND(AVG(MonthlyCharges), 2) AS Genel_ARPU_Aylik,
	ROUND(SUM(MonthlyCharges), 2) AS Toplam_Aylik_Gelir
FROM TelcoChurn
--Churn oranı %26,54
--%20 üzeri Telekomünikasyon sektörü için oldukça yüksek bir oran, ciddi bir retention problemi mevcut


--Kontrat Türüne Göre Churn ve ARPU Analizi (Kök Neden Analizi)
--Müşteriler en çok hangi kontrat türlerinde ayrılıyorlar?
SELECT
	Contract AS KontratTuru,
	COUNT(*) AS ToplamMusteri,
	SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnMusteriSayisi,
	ROUND(CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS ChurnOrani_Yuzde,
	ROUND(AVG(MonthlyCharges), 2) AS Ortalama_ARPU
FROM TelcoChurn
GROUP BY Contract
ORDER BY ChurnOrani_Yuzde DESC;
--Aylık churn oranı %40'ın üstünde 
--Yıllık %11 ve 2 Yıllık %2 seviyelerinde
--Şirketin müşterileri uzun süreli kontratlara teşvik eden kapmanyaları kurgulaması gerekir



--İnternet Hizemeti ve Müşteri Ömrü (Tenure) Analizi
--Aboneliğin ilk aylarındaki müşterilerin ayrılma riski
SELECT
	InternetService AS InternetTuru,
	CASE
		WHEN CAST(tenure AS INT) <= 12 THEN '0-1 Yıl (Yeni Müşteri)'
		WHEN CAST(tenure AS INT) <= 24 THEN '1-2 Yıl'
		ELSE '2+ Yıl (Sadık Müşteri)'
	END AS MusteriKidemi,
	COUNT(*) AS ToplamMusteri,
	ROUND(CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS ChurnOrani_Yuzde,
	ROUND(AVG(MonthlyCharges), 2) AS ARPU
FROM TelcoChurn
GROUP BY 
	InternetService,
	CASE
		WHEN CAST(tenure AS INT) <= 12 THEN '0-1 Yıl (Yeni Müşteri)'
		WHEN CAST(tenure AS INT) <= 24 THEN '1-2 Yıl'
		ELSE '2+ Yıl (Sadık Müşteri)'
	END
ORDER BY ChurnOrani_Yuzde DESC
--İlk 12 aydaki (özellikle Fiber Optic kullanan) yeni müşterilerin churn riskinin en yüksek grupta olduğu görülüyor: ~%70
		
