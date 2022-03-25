SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[grupy_wiekowe_pobyty] AS 
SELECT 
	TOP 12 FLOOR (
		DATEDIFF (
			YEAR, 
			p.data_urodzenia, 
			GETDATE ()
		) / 10
	)+ 1 AS grupa_wiekowa, 
	COUNT (pobyt.id_pobytu) AS liczba_pobytow 
FROM 
	pacjent p 
	INNER JOIN pobyt ON p.pesel_pacjent = pobyt.pesel_pacjent 
WHERE 
	YEAR (data_przyjecia)= YEAR (GETDATE()) 
GROUP BY 
	FLOOR (
		DATEDIFF (
			YEAR, 
			p.data_urodzenia, 
			GETDATE ()
		)/ 10
	)+ 1 
ORDER BY 
	grupa_wiekowa ASC
GO