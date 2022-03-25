CREATE TABLE [dbo].[pracownik] (
  [pesel_pracownik] [char](11) NOT NULL,
  [pesel_przelozony] [char](11) NULL,
  [nr_oddzialu] [numeric](2) NULL,
  [tytul] [char](21) NULL,
  [nazwisko] [char](64) NOT NULL,
  [imie] [char](64) NOT NULL,
  [drugie_imie] [char](64) NULL,
  [stanowisko] [char](100) NOT NULL,
  [specjalizacja] [char](100) NULL,
  [data_urodzenia] [date] NOT NULL,
  [nr_telefonu] [char](9) NOT NULL,
  [kod_pocztowy] [char](5) NOT NULL,
  [miejscowosc] [char](30) NOT NULL,
  [ulica] [char](92) NOT NULL,
  [nr_domu] [char](10) NOT NULL,
  [nr_lokalu] [char](3) NULL,
  [plec] [char](1) NOT NULL,
  [wynagrodzenie] [smallint] NOT NULL,
  [premia] [smallint] NULL,
  [staz] [numeric](2) NOT NULL CONSTRAINT [DF_pracownik_staz] DEFAULT (0),
  CONSTRAINT [PK_PRACOWNIK] PRIMARY KEY CLUSTERED ([pesel_pracownik]),
  CONSTRAINT [CKC_NR_ODDZIALU_PRACOWNI] CHECK ([nr_oddzialu] IS NULL OR [nr_oddzialu]>=(1) AND [nr_oddzialu]<=(999)),
  CONSTRAINT [CKC_PLEC_PRACOWNI] CHECK (([plec]='M' OR [plec]='K') AND [plec]=upper([plec])),
  CONSTRAINT [CKC_TYTUL_PRACOWNI] CHECK ([tytul] IS NULL OR ([tytul]='prof. dr hab. n. med.' OR [tytul]='dr hab. n. med.' OR [tytul]='dr n. med.' OR [tytul]='lekarz') AND [tytul]=lower([tytul])),
  CONSTRAINT [CKC_WYNAGRODZENIE_PRACOWNI] CHECK ([wynagrodzenie]>=(3079))
)
ON [PRIMARY]
GO

CREATE INDEX [ordynator_fk]
  ON [dbo].[pracownik] ([nr_oddzialu])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [pracownik_pk]
  ON [dbo].[pracownik] ([pesel_pracownik])
  ON [PRIMARY]
GO

CREATE INDEX [przelozony_fk]
  ON [dbo].[pracownik] ([pesel_przelozony])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_byly_pracownik]
ON [pracownik]
FOR DELETE
AS
	INSERT INTO byly_pracownik (pesel_pracownik, nr_oddzialu, tytul, nazwisko, imie, drugie_imie, stanowisko, specjalizacja, nr_telefonu,
     data_urodzenia, kod_pocztowy, miejscowosc, ulica, nr_domu, nr_lokalu, plec, wynagrodzenie, staz)
    SELECT pesel_pracownik, nr_oddzialu, tytul, nazwisko, imie, drugie_imie,
     stanowisko, specjalizacja, nr_telefonu, data_urodzenia, kod_pocztowy,
     miejscowosc, ulica, nr_domu, nr_lokalu, plec, wynagrodzenie, staz
	FROM deleted
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_pracownik]
ON [pracownik]
FOR INSERT, UPDATE
AS
DECLARE @stanowisko CHAR(50)
DECLARE @tytul BIT
DECLARE @specjalizacja BIT
DECLARE @oddzial BIT
DECLARE kursor CURSOR LOCAL FOR
	SELECT stanowisko,
		CASE WHEN tytul IS NULL THEN 0 ELSE 1 END,
		CASE WHEN specjalizacja IS NULL THEN 0 ELSE 1 END,
		CASE WHEN nr_oddzialu IS NULL THEN 0 ELSE 1 END
	FROM inserted
OPEN kursor
FETCH NEXT FROM kursor INTO @stanowisko, @tytul, @specjalizacja, @oddzial
WHILE @@FETCH_STATUS=0
BEGIN
	IF @stanowisko<>'lekarz' AND (@tytul=1 OR @oddzial=1)
		THROW 51000, 'Pielegniarz nie moze miec tytulu, ani byc ordynatorem', 1
	ELSE IF @stanowisko='lekarz' AND (@tytul=0 OR @specjalizacja=0)
		THROW 51000, 'Lekarz musi miec tytul oraz specjalizacji', 1
	FETCH NEXT FROM kursor INTO @stanowisko, @tytul, @specjalizacja, @oddzial
END
GO