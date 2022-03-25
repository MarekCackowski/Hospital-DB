SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[zastepstwo]( @dyzur date, @zmiana char(5), @pesel1 char(11), @pesel2 char(11) )
AS
BEGIN
	DECLARE @nowa_data date
    DECLARE @stanowisko1 char(50)
    DECLARE @stanowisko2 char(50)
    DECLARE @id_d1 char(7)
	DECLARE @id_d2 char(7)
    DECLARE @sala1 numeric(3,0)
    DECLARE @sala2 numeric(3,0)
	BEGIN TRY
		BEGIN TRAN
		SET @id_d2=(SELECT id_dyzur
					FROM dyzur
					WHERE pesel_pracownik=@pesel2 AND data_dyzur>GETDATE())
		SET @stanowisko1=(SELECT stanowisko
						  FROM pracownik
						  WHERE pesel_pracownik=@pesel1)
		SET @stanowisko2=(SELECT stanowisko
                          FROM pracownik
                          WHERE pesel_pracownik=@pesel2)
		SET @id_d1=(SELECT id_dyzur
					FROM dyzur
					WHERE DATEDIFF(DAY, data_dyzur, @dyzur)=0 AND pesel_pracownik=@pesel1 AND zmiana=@zmiana)
		SET @sala1=(SELECT nr_sali
					FROM dyzur
					WHERE id_dyzur=@id_d1)
		SET @sala2=(SELECT nr_sali
					FROM dyzur
					WHERE id_dyzur=@id_d2)
		IF @id_d2 IS NULL OR @stanowisko1<>@stanowisko2
		BEGIN
			PRINT 'NIE MOZNA ZAMIENIC DYZUROW DLA TYCH PRACOWNIKOW'
			ROLLBACK TRAN
		END
		ELSE IF @id_d1 IS NULL
		BEGIN
			PRINT 'PODANY PRACOWNIK NIE MA DYZURU W TYM TERMINIE'
			ROLLBACK TRAN
		END
		SET @nowa_data=(SELECT data_dyzur
                        FROM dyzur
                        WHERE id_dyzur=@id_d2)

		UPDATE dyzur
        SET data_dyzur=@nowa_data, nr_sali=@sala2
        WHERE id_dyzur=@id_d1
        UPDATE dyzur
        SET data_dyzur=@dyzur, nr_sali=@sala1
        WHERE id_dyzur=@id_d2
       
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
END
GO