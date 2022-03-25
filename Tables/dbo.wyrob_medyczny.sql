CREATE TABLE [dbo].[wyrob_medyczny] (
  [id_wyrobu] [char](7) NOT NULL,
  [nazwa_wyrobu] [char](50) NOT NULL,
  [liczba_egzemplarzy] [smallint] NOT NULL,
  CONSTRAINT [PK_WYROB_MEDYCZNY] PRIMARY KEY CLUSTERED ([id_wyrobu]),
  CONSTRAINT [CKC_LICZBA_EGZEMPLARZ_WYROB_ME] CHECK ([liczba_egzemplarzy]>=(0))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [wyrob_medyczny_pk]
  ON [dbo].[wyrob_medyczny] ([id_wyrobu])
  ON [PRIMARY]
GO