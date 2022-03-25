CREATE TABLE [dbo].[pobyt] (
  [pesel_pacjent] [char](11) NOT NULL,
  [id_pobytu] [char](7) NOT NULL,
  [id_skierowania] [char](7) NULL,
  [nr_sali] [numeric](3) NOT NULL,
  [data_przyjecia] [datetime] NOT NULL,
  [data_wypisu] [datetime] NULL,
  [nr_lozka] [numeric](1) NOT NULL,
  CONSTRAINT [PK_POBYT] PRIMARY KEY CLUSTERED ([id_pobytu]),
  CONSTRAINT [CKC_NR_LOZKA_POBYT] CHECK ([nr_lozka]>=(1) AND [nr_lozka]<=(8)),
  CONSTRAINT [CKC_NR_SALI_POBYT] CHECK ([nr_sali]>=(1) AND [nr_sali]<=(999))
)
ON [PRIMARY]
GO

CREATE INDEX [odbywa_sie_fk]
  ON [dbo].[pobyt] ([nr_sali])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [pobyt_pk]
  ON [dbo].[pobyt] ([id_pobytu])
  ON [PRIMARY]
GO

CREATE INDEX [umozliwia2_fk]
  ON [dbo].[pobyt] ([id_skierowania])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_pobyt]
ON [pobyt]
FOR INSERT, UPDATE
AS
DECLARE @liczba_lozek INT
DECLARE @nr_lozka INT
DECLARE kursor CURSOR LOCAL FOR
	SELECT liczba_lozek, nr_lozka
	FROM sala INNER JOIN inserted ON sala.nr_sali=inserted.nr_sali
OPEN kursor
FETCH NEXT FROM kursor INTO @liczba_lozek, @nr_lozka
WHILE @@FETCH_STATUS=0
BEGIN
	IF @liczba_lozek<@nr_lozka
		THROW 51000, 'Nie ma lozka o takim numerze w tej sali', 1
	FETCH NEXT FROM kursor INTO @liczba_lozek, @nr_lozka
END
GO