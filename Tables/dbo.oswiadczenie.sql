CREATE TABLE [dbo].[oswiadczenie] (
  [id_oswiadczenia] [char](7) NOT NULL,
  [pesel_pacjent] [char](11) NOT NULL,
  [typ_oswiadczenia] [numeric](1) NOT NULL,
  [data_zlozenia] [date] NOT NULL,
  CONSTRAINT [PK_OSWIADCZENIE] PRIMARY KEY CLUSTERED ([id_oswiadczenia]),
  CONSTRAINT [CKC_TYP_OSWIADCZENIA_OSWIADCZ] CHECK ([typ_oswiadczenia]=(2) OR [typ_oswiadczenia]=(1))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [oswiadczenie_pk]
  ON [dbo].[oswiadczenie] ([id_oswiadczenia])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [uidxo_oswiadczenie]
  ON [dbo].[oswiadczenie] ([pesel_pacjent], [typ_oswiadczenia])
  ON [PRIMARY]
GO

CREATE INDEX [wypelnia_FK]
  ON [dbo].[oswiadczenie] ([pesel_pacjent])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_zmiana_oswiadczenia]
ON [dbo].[oswiadczenie]
FOR INSERT, UPDATE
AS
DECLARE @typ_oswiadczenia TINYINT
DECLARE @pesel CHAR(11)
DECLARE kursor CURSOR LOCAL FOR
	SELECT typ_oswiadczenia, pesel_pacjent
	FROM inserted
BEGIN TRY
	OPEN kursor
	FETCH NEXT FROM kursor INTO @typ_oswiadczenia, @pesel
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF @typ_oswiadczenia=1
		BEGIN
			BEGIN TRAN
			DELETE
			FROM oswiadczenie
			WHERE typ_oswiadczenia=1 AND pesel_pacjent=@pesel
			COMMIT TRAN
		END
		ELSE
		BEGIN
			BEGIN TRAN
			DELETE
			FROM oswiadczenie
			WHERE typ_oswiadczenia=2 AND pesel_pacjent=@pesel
			COMMIT TRAN
		END
		FETCH NEXT FROM kursor INTO @typ_oswiadczenia, @pesel
	END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	BEGIN
		PRINT 'TRANSACTION ERROR IN TRG_ZMIANA_OSWIADCZENIA'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT 'ERROR'
    END
END CATCH

GO

ALTER TABLE [dbo].[oswiadczenie]
  ADD CONSTRAINT [wypełnia] FOREIGN KEY ([pesel_pacjent]) REFERENCES [dbo].[pacjent] ([pesel_pacjent]) ON DELETE CASCADE ON UPDATE CASCADE
GO