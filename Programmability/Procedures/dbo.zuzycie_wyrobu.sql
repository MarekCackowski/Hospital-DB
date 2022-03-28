SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[zuzycie_wyrobu]( @zId char(7) )
AS
BEGIN
    DECLARE @licznik int
    DECLARE @zuzyte int
    DECLARE @liczba int
    DECLARE @w_id char(7)
   	DECLARE kursor CURSOR FORWARD_ONLY LOCAL FOR
        SELECT
			id_wyrobu, liczba_zuzytych
        FROM
			zuzycie
        WHERE
			id_zabiegu=@zId
    OPEN kursor
	BEGIN TRY
		BEGIN TRAN
        SET @licznik=0
        FETCH NEXT FROM kursor INTO @w_id, @zuzyte
        WHILE @@FETCH_STATUS=0
            BEGIN
                SET @liczba=(SELECT liczba_egzemplarzy
                             FROM wyrob_medyczny
                             WHERE id_wyrobu=@w_id)
                IF @liczba>=@zuzyte 
                    BEGIN
                        UPDATE wyrob_medyczny
                        SET liczba_egzemplarzy=@liczba-@zuzyte
                        WHERE id_wyrobu=@w_id
                    END
                ELSE
                    BEGIN
                        SET @licznik=1
                    END
                FETCH NEXT FROM kursor INTO @w_id, @zuzyte
            END
        IF @licznik=0
            BEGIN
                DELETE zuzycie
                WHERE id_zabiegu=@zId
                COMMIT TRAN
            END
        ELSE
            BEGIN
                ROLLBACK TRAN
            END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
			PRINT 'ERROR IN TRANSACTION'
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