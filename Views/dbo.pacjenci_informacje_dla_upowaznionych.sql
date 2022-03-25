SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[pacjenci_informacje_dla_upowaznionych] AS 
SELECT 
	p.nazwisko, 
	p.imie, 
	ski.nr_sali, 
	czy_posiada_skierowanie, 
	COUNT (DISTINCT b.id_badania) AS liczba_wykonanych_badan, 
	STUFF (
		(		
			SELECT 
				', ' + TRIM(tz.nazwa_zabiegu) 
			FROM 
				typ_zabiegu tz 
				INNER JOIN zabieg z ON z.nazwa_zabiegu = tz.nazwa_zabiegu 
			WHERE 
				z.pesel_pacjent = p.pesel_pacjent FOR XML PATH('')
		), 
		1, 
		1, 
		''
	) AS zabiegi, 
	(		
		SELECT 
			TOP 1 TRIM (nazwisko) + ' ' + TRIM(imie)+ ', ' + 
				LEAD(TRIM (nazwisko) + ' ' + TRIM(imie)) OVER(ORDER BY p.pesel_pacjent) 
		FROM 
			osoba_upowazniona osu1 
			INNER JOIN upowaznia up1 ON osu1.id_upowaznionej = up1.id_upowaznionej 
			INNER JOIN oswiadczenie os1 ON up1.id_oswiadczenia = os1.id_oswiadczenia 
		WHERE 
			os1.pesel_pacjent = p.pesel_pacjent 
			AND typ_oswiadczenia = 1 
		ORDER BY 
			p.pesel_pacjent
	) AS osoby_upowaznione 
FROM 
	(		SELECT 
			ou.id_upowaznionej, 
			ou.nazwisko, 
			ou.imie, 
			o.pesel_pacjent 
		FROM 
			osoba_upowazniona ou 
			INNER JOIN upowaznia u ON ou.id_upowaznionej = u.id_upowaznionej 
			INNER JOIN oswiadczenie o ON o.id_oswiadczenia = u.id_oswiadczenia 
		WHERE 
			typ_oswiadczenia = 1
	) AS osw 
	INNER JOIN pacjent p ON p.pesel_pacjent = osw.pesel_pacjent 
	INNER JOIN (	
		SELECT 
			pobyt.pesel_pacjent, 
			pobyt.id_pobytu, 
			nr_lozka, 
			sala.nr_sali, 
			CASE
				WHEN pobyt.id_skierowania IS NULL THEN 'NIE'
				ELSE 'TAK'
			END AS czy_posiada_skierowanie, 
			skierowanie.id_skierowania 
		FROM 
			pobyt 
			INNER JOIN sala ON sala.nr_sali = pobyt.nr_sali 
			LEFT JOIN skierowanie ON skierowanie.id_skierowania = pobyt.id_skierowania 
		WHERE 
			DATEDIFF(
				DAY, 
				data_przyjecia, 
				GETDATE()
			) >= 0 
			AND data_wypisu IS NULL
	) AS ski ON ski.pesel_pacjent = p.pesel_pacjent 
	INNER JOIN badanie b ON b.id_pobytu = ski.id_pobytu 
	OR b.id_skierowania = ski.id_skierowania 
WHERE 
	data_badania <= GETDATE() 
GROUP BY 
	p.pesel_pacjent, 
	p.nazwisko, 
	p.imie, 
	ski.nr_sali, 
	czy_posiada_skierowanie
GO