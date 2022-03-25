SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[srednie_wynagrodzenie_pielegniarze]()
RETURNS FLOAT
AS
BEGIN
	DECLARE @srednia INT
	DECLARE @suma FLOAT
	DECLARE @licznik FLOAT
	SET @suma=(SELECT SUM(wynagrodzenie)
			   FROM pracownik
			   WHERE stanowisko='pielegniarz')
	SET @licznik=(SELECT COUNT(*)
				  FROM pracownik
				  WHERE stanowisko='pielegniarz')
	IF @licznik<>0
	BEGIN
		SET @srednia=@suma/@licznik
	END
	ELSE
	BEGIN
		SET @srednia=0
	END
	RETURN CAST(@srednia AS INT)
END
GO