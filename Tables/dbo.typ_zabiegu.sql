CREATE TABLE [dbo].[typ_zabiegu] (
  [nazwa_zabiegu] [char](50) NOT NULL,
  [opis_zabiegu] [varchar](1) NULL,
  CONSTRAINT [PK_TYP_ZABIEGU] PRIMARY KEY CLUSTERED ([nazwa_zabiegu])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [typ_zabiegu_pk]
  ON [dbo].[typ_zabiegu] ([nazwa_zabiegu])
  ON [PRIMARY]
GO