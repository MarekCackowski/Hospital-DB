SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[wizyty_ze_skierowaniem] AS 
SELECT 
	TOP 100 p.nazwisko, 
	p.imie, 
	(	
		SELECT 
			COUNT(s1.pesel_pacjent) 
		FROM 
			skierowanie s1 
		WHERE 
			s1.pesel_pacjent = s.pesel_pacjent 
			AND s1.id_lekarza IS NOT NULL
	) AS wizyty_ze_skierowaniem 
FROM 
	pacjent p 
	INNER JOIN skierowanie s ON p.pesel_pacjent = s.pesel_pacjent 
	INNER JOIN badanie b ON s.id_skierowania = b.id_skierowania 
WHERE 
	b.pesel_pracownik IS NULL 
GROUP BY 
	p.pesel_pacjent, 
	p.nazwisko, 
	p.imie, 
	s.pesel_pacjent 
ORDER BY 
	3 DESC, 
	COUNT(b.id_badania) DESC
GO