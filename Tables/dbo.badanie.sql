CREATE TABLE [dbo].[badanie] (
  [id_badania] [char](7) NOT NULL,
  [id_skierowania] [char](7) NULL,
  [pesel_pacjent] [char](11) NOT NULL,
  [id_pobytu] [char](7) NULL,
  [id_lekarza] [char](7) NULL,
  [pesel_pracownik] [char](11) NULL,
  [typ_badania] [char](100) NOT NULL,
  [data_badania] [date] NOT NULL,
  [data_podpisania] [date] NULL,
  [opis_badania] [varchar](1) NOT NULL,
  CONSTRAINT [PK_BADANIE] PRIMARY KEY CLUSTERED ([id_badania])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [badanie_pk]
  ON [dbo].[badanie] ([id_badania])
  ON [PRIMARY]
GO

CREATE INDEX [dostarcza_wynik_nagły_fk]
  ON [dbo].[badanie] ([id_pobytu])
  ON [PRIMARY]
GO

CREATE INDEX [jest_zalaczane_fk]
  ON [dbo].[badanie] ([id_skierowania])
  ON [PRIMARY]
GO

CREATE INDEX [wykorzystuje_dane_fk]
  ON [dbo].[badanie] ([pesel_pacjent])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[badanie]
  ADD CONSTRAINT [badanie_dostarcza_nagły] FOREIGN KEY ([id_pobytu]) REFERENCES [dbo].[pobyt] ([id_pobytu]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[badanie]
  ADD CONSTRAINT [badanie_przeprowadza_nagły] FOREIGN KEY ([pesel_pracownik]) REFERENCES [dbo].[pracownik] ([pesel_pracownik]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[badanie]
  ADD CONSTRAINT [badanie_wykonuje_zwykły] FOREIGN KEY ([id_lekarza]) REFERENCES [dbo].[lekarz] ([id_lekarza]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[badanie]
  ADD CONSTRAINT [jest załączane] FOREIGN KEY ([id_skierowania]) REFERENCES [dbo].[skierowanie] ([id_skierowania]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[badanie]
  ADD CONSTRAINT [wykorzystuje_dane] FOREIGN KEY ([pesel_pacjent]) REFERENCES [dbo].[pacjent] ([pesel_pacjent]) ON DELETE CASCADE ON UPDATE CASCADE
GO