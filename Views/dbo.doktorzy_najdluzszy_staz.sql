SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[doktorzy_najdluzszy_staz] AS 
SELECT 
	TOP 100 CONCAT (
		TRIM (tytul), 
		' ', 
		TRIM (nazwisko), 
		' ', 
		TRIM (imie)
	) AS doktor, 
	nazwa_oddzialu 
FROM 
	(	
		SELECT 
			p1.pesel_pracownik, 
			RANK() OVER(
				PARTITION BY o1.nazwa_oddzialu 
				ORDER BY 
					p1.staz DESC
			) AS pozycja 
		FROM 
			pracownik p1 
			INNER JOIN oddzial o1 ON p1.nr_oddzialu = o1.nr_oddzialu 
		WHERE 
			stanowisko = 'lekarz'
	) X 
	INNER JOIN pracownik p ON x.pesel_pracownik = p.pesel_pracownik 
	INNER JOIN oddzial o ON p.nr_oddzialu = o.nr_oddzialu 
WHERE 
	pozycja < 4 
	AND tytul LIKE '%dr%' 
ORDER BY 
	nazwa_oddzialu ASC
GO