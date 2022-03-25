CREATE TABLE [dbo].[sala] (
  [nr_sali] [numeric](3) NOT NULL,
  [nr_oddzialu] [numeric](2) NOT NULL,
  [typ_sali] [numeric](1) NOT NULL,
  [liczba_lozek] [numeric](1) NULL,
  CONSTRAINT [PK_SALA] PRIMARY KEY CLUSTERED ([nr_sali]),
  CONSTRAINT [CKC_LICZBA_LOZEK_SALA] CHECK ([liczba_lozek] IS NULL OR [liczba_lozek]>=(1) AND [liczba_lozek]<=(8)),
  CONSTRAINT [CKC_NR_ODDZIALU_SALA] CHECK ([nr_oddzialu]>=(1) AND [nr_oddzialu]<=(999)),
  CONSTRAINT [CKC_NR_SALI_SALA] CHECK ([nr_sali]>=(1) AND [nr_sali]<=(999)),
  CONSTRAINT [CKC_TYP_SALI_SALA] CHECK ([typ_sali]>=(0) AND [typ_sali]<=(3) AND ([typ_sali]=(3) OR [typ_sali]=(2) OR [typ_sali]=(1) OR [typ_sali]=(0)))
)
ON [PRIMARY]
GO

CREATE INDEX [posiada_fk]
  ON [dbo].[sala] ([nr_oddzialu])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [sala_pk]
  ON [dbo].[sala] ([nr_sali])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_sala]
ON [sala]
FOR INSERT, UPDATE
AS
DECLARE @typ_sali INT
DECLARE @liczba_lozek BIT
DECLARE kursor CURSOR LOCAL FOR
	SELECT typ_sali,
		CASE WHEN liczba_lozek IS NULL THEN 0 ELSE 1 END
	FROM inserted
OPEN kursor
FETCH NEXT FROM kursor INTO @typ_sali, @liczba_lozek
WHILE @@FETCH_STATUS=0
BEGIN
	IF @typ_sali=0 AND @liczba_lozek=0
		THROW 51000, 'Na sali chorych musza byc lozka', 1
	ELSE IF @typ_sali>0 AND @liczba_lozek=1
		THROW 51000, 'Lozka moga byc tylko na sali chorych', 1
	FETCH NEXT FROM kursor INTO @typ_sali, @liczba_lozek
END
GO