SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[zmien_typ_sali]( @nr_sali numeric(3,0), @zmiana numeric(1,0), @lozka numeric(1,0), @przeniesienie numeric(3,0) )
AS
BEGIN
	DECLARE @typ_sali INT
	DECLARE @liczba_lozek INT
	BEGIN TRY
		BEGIN TRAN
		SET @typ_sali=(SELECT typ_sali
					   FROM sala
					   WHERE nr_sali=@nr_sali)
		IF @typ_sali=@zmiana 
		BEGIN
			PRINT 'PODANY TYP SALI TO JEST AKTUALNY TYP'
			ROLLBACK TRAN
		END
		ELSE IF @typ_sali>0 AND @zmiana=0
		BEGIN
			UPDATE sala
			SET typ_sali=@zmiana, liczba_lozek=@lozka
			WHERE nr_sali=@nr_sali
			COMMIT TRAN
		END
		ELSE IF @typ_sali>0 AND @zmiana>0
		BEGIN
			UPDATE sala
			SET typ_sali=@zmiana
			WHERE nr_sali=@nr_sali
			COMMIT TRAN
		END
		ELSE
		BEGIN
			SET @liczba_lozek=(SELECT liczba_lozek
								   FROM sala
								   WHERE nr_sali=@nr_sali)
			UPDATE sala
			SET liczba_lozek=liczba_lozek+@liczba_lozek
			WHERE nr_sali=@przeniesienie
			UPDATE sala
			SET typ_sali=@zmiana, liczba_lozek=NULL
			WHERE nr_sali=@nr_sali
			IF 0<>(SELECT typ_sali
				   FROM sala
				   WHERE nr_sali=@przeniesienie)
			BEGIN
				PRINT 'SALA DO KTOREJ PROBUJESZ PRZENIESC LOZKA NIE JEST SALA CHORYCH'
				ROLLBACK TRAN
			END
			ELSE IF 8<=(SELECT liczba_lozek
					   FROM sala
					   WHERE nr_sali=@przeniesienie)
			BEGIN
				PRINT 'SALA DO KTOREJ PROBUJESZ PRZENIESC LOZKA JEST ZA MALA'
				ROLLBACK TRAN
			END
			ELSE
				COMMIT TRAN
		END
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