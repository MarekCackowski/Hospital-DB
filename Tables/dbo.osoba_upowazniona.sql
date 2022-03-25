CREATE TABLE [dbo].[osoba_upowazniona] (
  [id_upowaznionej] [char](7) NOT NULL,
  [nazwisko] [char](64) NOT NULL,
  [imie] [char](64) NOT NULL,
  [nr_telefonu] [char](9) NOT NULL,
  [kod_pocztowy] [char](5) NOT NULL,
  [miejscowosc] [char](30) NOT NULL,
  [ulica] [char](92) NOT NULL,
  [nr_domu] [char](10) NOT NULL,
  [nr_lokalu] [char](3) NULL,
  CONSTRAINT [PK_OSOBA_UPOWAZNIONA] PRIMARY KEY CLUSTERED ([id_upowaznionej])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [osoba_upowazniona_pk]
  ON [dbo].[osoba_upowazniona] ([id_upowaznionej])
  ON [PRIMARY]
GO