SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[premia_covid] 
AS
BEGIN
	DECLARE @pesel CHAR(11)
	DECLARE @liczba_dni INT
	DECLARE @srednie_wynagrodzenie INT
	DECLARE kursor CURSOR FORWARD_ONLY LOCAL FOR
		SELECT 
			p.pesel_pracownik, 
			COUNT(d.id_dyzur) 
		FROM 
			pracownik p 
			INNER JOIN dyzur d ON p.pesel_pracownik = d.pesel_pracownik 
			INNER JOIN sala s ON d.nr_sali = s.nr_sali 
			INNER JOIN oddzial o ON s.nr_oddzialu = o.nr_oddzialu 
		WHERE 
			stanowisko = 'pielegniarz' 
			AND nazwa_oddzialu = 'Chorób zakaźnych' 
			AND data_dyzur < GETDATE()
			AND DATEDIFF(
				YEAR, 
				data_dyzur, 
				GETDATE ()
			)= 0 
		GROUP BY 
			p.pesel_pracownik
	SET TRAN ISOLATION LEVEL SERIALIZABLE
	BEGIN TRY
		BEGIN TRAN
		OPEN kursor
		FETCH NEXT FROM kursor INTO @pesel, @liczba_dni
		WHILE @@FETCH_STATUS=0
		BEGIN
			IF @liczba_dni>=20
			BEGIN
				SET @srednie_wynagrodzenie=[dbo].[srednie_wynagrodzenie_pielegniarze]()
				UPDATE pracownik
				SET premia=premia+@liczba_dni*@srednie_wynagrodzenie/50
				WHERE pesel_pracownik=@pesel
			END
			FETCH NEXT FROM kursor INTO @pesel, @liczba_dni
		END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
		BEGIN
			PRINT 'TRANSACTION ERROR'
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			PRINT 'ERROR'
		END
	END CATCH
	SET TRAN ISOLATION LEVEL READ COMMITTED
	CLOSE kursor
	DEALLOCATE kursor
END
GO