CREATE TABLE [dbo].[zabieg] (
  [pesel_pacjent] [char](11) NOT NULL,
  [id_pobytu] [char](7) NOT NULL,
  [nazwa_zabiegu] [char](50) NOT NULL,
  [id_zespolu] [char](7) NOT NULL,
  [id_zabiegu] [char](7) NOT NULL,
  [data_poczatek] [datetime] NOT NULL,
  [data_koniec] [datetime] NOT NULL,
  CONSTRAINT [PK_ZABIEG] PRIMARY KEY CLUSTERED ([nazwa_zabiegu], [id_zabiegu])
)
ON [PRIMARY]
GO

CREATE INDEX [jaki_fk]
  ON [dbo].[zabieg] ([nazwa_zabiegu])
  ON [PRIMARY]
GO

CREATE INDEX [ktory_wykonuje_fk]
  ON [dbo].[zabieg] ([id_zespolu])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [zabieg_pk]
  ON [dbo].[zabieg] ([nazwa_zabiegu], [id_zabiegu])
  ON [PRIMARY]
GO