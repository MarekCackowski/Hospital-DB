CREATE TABLE [dbo].[lekarz] (
  [id_lekarza] [char](7) NOT NULL,
  [tytul] [char](21) NOT NULL,
  [nazwisko] [char](64) NOT NULL,
  [imie] [char](64) NOT NULL,
  [specjalizacja] [char](100) NOT NULL,
  CONSTRAINT [PK_LEKARZ] PRIMARY KEY CLUSTERED ([id_lekarza]),
  CONSTRAINT [CKC_TYTUL_LEKARZ] CHECK (([tytul]='prof. dr hab. n. med.' OR [tytul]='dr hab. n. med.' OR [tytul]='dr n. med.' OR [tytul]='lekarz') AND [tytul]=lower([tytul]))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [lekarz_pk]
  ON [dbo].[lekarz] ([id_lekarza])
  ON [PRIMARY]
GO