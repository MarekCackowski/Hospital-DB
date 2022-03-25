CREATE TABLE [dbo].[dyzur] (
  [id_dyzur] [char](7) NOT NULL,
  [data_dyzur] [date] NOT NULL,
  [zmiana] [char](5) NOT NULL,
  [pesel_pracownik] [char](11) NULL,
  [nr_sali] [numeric](3) NULL,
  CONSTRAINT [PK_DYZUR] PRIMARY KEY CLUSTERED ([id_dyzur]),
  CONSTRAINT [CKC_NR_SALI_DYZUR] CHECK ([nr_sali] IS NULL OR [nr_sali]>=(1) AND [nr_sali]<=(999)),
  CONSTRAINT [CKC_ZMIANA_DYZUR] CHECK ([zmiana]='noc' OR [zmiana]='dzien')
)
ON [PRIMARY]
GO

CREATE INDEX [ktory_ma_fk]
  ON [dbo].[dyzur] ([pesel_pracownik])
  ON [PRIMARY]
GO

CREATE INDEX [pielegniarz_fk]
  ON [dbo].[dyzur] ([nr_sali])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [uidxz_dyzur]
  ON [dbo].[dyzur] ([data_dyzur], [zmiana], [pesel_pracownik])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_dyzur]
ON [dbo].[dyzur]
FOR INSERT, UPDATE
AS
	DECLARE @nr_sali INT
	DECLARE @pesel CHAR(11)
	DECLARE @stanowisko CHAR(50)
	DECLARE kursor CURSOR LOCAL FOR
		SELECT pesel_pracownik, nr_sali
		FROM inserted
	OPEN kursor
	FETCH NEXT FROM kursor INTO @pesel, @nr_sali
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @stanowisko=(SELECT stanowisko
						 FROM pracownik
						 WHERE pesel_pracownik=@pesel)
		IF @nr_sali IS NOT NULL AND @stanowisko='lekarz'
			THROW 51000, 'Lekarz nie ma okreslonej sali podczas dyzuru', 1
		ELSE IF @nr_sali IS NULL AND @stanowisko<>'lekarz'
			THROW 51000, 'Pielegniarz odbywa dyzur na okreslonej sali', 1
		FETCH NEXT FROM kursor INTO @pesel, @nr_sali
	END
GO

ALTER TABLE [dbo].[dyzur]
  ADD CONSTRAINT [który_ma] FOREIGN KEY ([pesel_pracownik]) REFERENCES [dbo].[pracownik] ([pesel_pracownik]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[dyzur]
  ADD CONSTRAINT [pielęgniarz] FOREIGN KEY ([nr_sali]) REFERENCES [dbo].[sala] ([nr_sali]) ON DELETE CASCADE ON UPDATE CASCADE
GO