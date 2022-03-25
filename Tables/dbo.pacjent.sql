CREATE TABLE [dbo].[pacjent] (
  [pesel_pacjent] [char](11) NOT NULL,
  [nr_sali] [numeric](3) NULL,
  [nazwisko] [char](64) NOT NULL,
  [imie] [char](64) NOT NULL,
  [drugie_imie] [char](64) NULL,
  [nr_telefonu] [char](9) NOT NULL,
  [data_urodzenia] [date] NOT NULL,
  [kod_pocztowy] [char](5) NOT NULL,
  [miejscowosc] [char](30) NOT NULL,
  [ulica] [char](92) NOT NULL,
  [nr_domu] [char](10) NOT NULL,
  [nr_lokalu] [char](3) NULL,
  [plec] [char](1) NOT NULL,
  [dieta] [char](100) NULL DEFAULT ('podstawowa'),
  CONSTRAINT [PK_PACJENT] PRIMARY KEY CLUSTERED ([pesel_pacjent]),
  CONSTRAINT [CKC_NR_SALI_PACJENT] CHECK ([nr_sali] IS NULL OR [nr_sali]>=(1) AND [nr_sali]<=(999)),
  CONSTRAINT [CKC_PLEC_PACJENT] CHECK (([plec]='M' OR [plec]='K') AND [plec]=upper([plec]))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [pacjent_pk]
  ON [dbo].[pacjent] ([pesel_pacjent])
  ON [PRIMARY]
GO

CREATE INDEX [przebywa_na_fk]
  ON [dbo].[pacjent] ([nr_sali])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[pacjent]
  ADD CONSTRAINT [przebywa_na] FOREIGN KEY ([nr_sali]) REFERENCES [dbo].[sala] ([nr_sali]) ON DELETE CASCADE ON UPDATE CASCADE
GO