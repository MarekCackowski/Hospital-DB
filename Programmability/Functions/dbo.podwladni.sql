SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[podwladni] (
	@pesel CHAR (11)
)
RETURNS TABLE
AS
RETURN
	WITH X AS(
	SELECT 
		pesel_pracownik, 
		nazwisko, 
		imie, 
		pesel_przelozony 
	FROM 
		pracownik 
	WHERE 
		pesel_przelozony = @pesel 
	UNION ALL	SELECT 
		p.pesel_pracownik, 
		p.nazwisko, 
		p.imie, 
		p.pesel_przelozony 
	FROM 
		pracownik p 
		INNER JOIN X ON x.pesel_pracownik = p.pesel_przelozony
	) 
	SELECT 
		pesel_pracownik, 
		nazwisko, 
		imie 
	FROM 
		x
GO