SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[przyznaj_premie]
AS
BEGIN
	DECLARE @premia INT
	DECLARE @pesel CHAR(11)
	DECLARE kursor CURSOR LOCAL FOR
		SELECT 
			TOP 1 WITH TIES p.pesel_pracownik 
		FROM 
			(		SELECT 
					ze1.id_zespolu, 
					d1.id_dyzur 
				FROM 
					dyzur d1 
					INNER JOIN czlonek_zespolu c1 ON d1.id_dyzur = c1.id_dyzur 
					INNER JOIN zespol_operacyjny ze1 ON c1.id_zespolu = ze1.id_zespolu 
				UNION ALL		SELECT 
					ze2.id_zespolu, 
					d2.id_dyzur 
				FROM 
					dyzur d2 
					INNER JOIN zespol_operacyjny ze2 ON d2.id_dyzur = ze2.id_dyzur
			) AS X 
			INNER JOIN zabieg za ON x.id_zespolu = za.id_zespolu 
			INNER JOIN dyzur d ON x.id_dyzur = d.id_dyzur 
			INNER JOIN pracownik p ON d.pesel_pracownik = p.pesel_pracownik 
		WHERE 
			stanowisko = 'lekarz' 
			AND DATEDIFF (
				MONTH, 
				data_poczatek, 
				GETDATE ()
			)= 0 
		GROUP BY 
			p.pesel_pracownik 
		HAVING 
			COUNT(za.id_zabiegu) > 10 
		ORDER BY 
			COUNT (za.id_zabiegu) DESC
	BEGIN TRY
		BEGIN TRAN
		OPEN kursor
		FETCH NEXT FROM kursor INTO @pesel
		WHILE @@FETCH_STATUS=0 
		BEGIN
			SET @premia=(SELECT premia
						 FROM pracownik
						 WHERE pesel_pracownik=@pesel)
			IF @premia IS NULL
			BEGIN
				UPDATE pracownik
				SET premia=1000
				WHERE pesel_pracownik=@pesel
			END
			ELSE
			BEGIN
				UPDATE pracownik
				SET premia=premia+1000
				WHERE pesel_pracownik=@pesel
			END
			FETCH NEXT FROM kursor INTO @pesel
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
	CLOSE kursor
	DEALLOCATE kursor
END
GO