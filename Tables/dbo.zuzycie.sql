CREATE TABLE [dbo].[zuzycie] (
  [id_wyrobu] [char](7) NOT NULL,
  [nazwa_zabiegu] [char](50) NOT NULL,
  [id_zabiegu] [char](7) NOT NULL,
  [liczba_zuzytych] [smallint] NOT NULL,
  CONSTRAINT [PK_ZUZYCIE] PRIMARY KEY CLUSTERED ([nazwa_zabiegu], [id_wyrobu], [id_zabiegu]),
  CONSTRAINT [CKC_LICZBA_ZUZYTYCH_ZUZYCIE] CHECK ([liczba_zuzytych]>=(0))
)
ON [PRIMARY]
GO

CREATE INDEX [powoduje_FK]
  ON [dbo].[zuzycie] ([nazwa_zabiegu], [id_zabiegu])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [zuzycie_pk]
  ON [dbo].[zuzycie] ([nazwa_zabiegu], [id_wyrobu], [id_zabiegu])
  ON [PRIMARY]
GO

CREATE INDEX [zuzywa_fk]
  ON [dbo].[zuzycie] ([id_wyrobu])
  ON [PRIMARY]
GO