CREATE TABLE [dbo].[uzywa] (
  [nazwa_zabiegu] [char](50) NOT NULL,
  [id_zabiegu] [char](7) NOT NULL,
  [id_wyrobu] [char](7) NOT NULL,
  CONSTRAINT [PK_UZYWA] PRIMARY KEY CLUSTERED ([nazwa_zabiegu], [id_zabiegu], [id_wyrobu])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [uzywa_pk]
  ON [dbo].[uzywa] ([nazwa_zabiegu], [id_zabiegu], [id_wyrobu])
  ON [PRIMARY]
GO

CREATE INDEX [uzywa2_fk]
  ON [dbo].[uzywa] ([id_wyrobu])
  ON [PRIMARY]
GO