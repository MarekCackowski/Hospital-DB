CREATE TABLE [dbo].[byly_pracownik] (
  [idp] [int] IDENTITY,
  [data_zwolnienia] [date] NULL DEFAULT (getdate()),
  [pesel_pracownik] [char](11) NULL,
  [pesel_przelozony] [char](11) NULL,
  [nr_oddzialu] [numeric](2) NULL,
  [tytul] [char](21) NULL,
  [nazwisko] [char](64) NULL,
  [imie] [char](64) NULL,
  [drugie_imie] [char](64) NULL,
  [stanowisko] [char](100) NULL,
  [specjalizacja] [char](100) NULL,
  [data_urodzenia] [date] NULL,
  [nr_telefonu] [char](9) NULL,
  [kod_pocztowy] [char](5) NULL,
  [miejscowosc] [char](30) NULL,
  [ulica] [char](92) NULL,
  [nr_domu] [char](10) NULL,
  [nr_lokalu] [char](3) NULL,
  [plec] [char](1) NULL,
  [wynagrodzenie] [smallint] NULL,
  [staz] [numeric](2) NULL,
  PRIMARY KEY CLUSTERED ([idp])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [byly_pracownik_pk]
  ON [dbo].[byly_pracownik] ([idp])
  ON [PRIMARY]
GO