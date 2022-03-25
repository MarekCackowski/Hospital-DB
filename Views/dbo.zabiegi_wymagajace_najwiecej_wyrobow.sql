SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[zabiegi_wymagajace_najwiecej_wyrobow] AS 
SELECT 
	TOP 3 tz.nazwa_zabiegu, 
	SUM (x.suma) AS srednia_liczba_wyrobow 
FROM 
	(	
		SELECT 
			z1.nazwa_zabiegu AS nazwa, 
			ROUND(
				CAST(
					AVG(zuzycie.liczba_zuzytych) AS float
				), 
				2
			) AS suma 
		FROM 
			zabieg z1 
			INNER JOIN zuzycie ON z1.id_zabiegu = zuzycie.id_zabiegu 
		GROUP BY 
			z1.nazwa_zabiegu 
		UNION ALL		
		SELECT 
			z2.nazwa_zabiegu AS nazwa, 
			ROUND(
				CAST(
					COUNT(uzywa.id_wyrobu) AS float
				)/ (					SELECT 
						COUNT(DISTINCT id_zabiegu) 
					FROM 
						uzywa 
					WHERE 
						nazwa_zabiegu = z2.nazwa_zabiegu
				), 
				2
			) AS suma 
		FROM 
			zabieg z2 
			INNER JOIN uzywa ON z2.id_zabiegu = uzywa.id_zabiegu 
		GROUP BY 
			z2.nazwa_zabiegu
	) X 
	INNER JOIN typ_zabiegu tz ON tz.nazwa_zabiegu = x.nazwa 
GROUP BY 
	tz.nazwa_zabiegu 
ORDER BY 
	2 DESC
GO