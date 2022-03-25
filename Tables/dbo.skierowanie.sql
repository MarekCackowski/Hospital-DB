CREATE TABLE [dbo].[skierowanie] (
  [id_skierowania] [char](7) NOT NULL,
  [pesel_pacjent] [char](11) NOT NULL,
  [id_pobytu] [char](7) NOT NULL,
  [id_lekarza] [char](7) NOT NULL,
  [icd11] [char](6) NOT NULL,
  [rozpoznanie] [char](100) NOT NULL,
  [termin_przyjecia] [date] NOT NULL,
  CONSTRAINT [PK_SKIEROWANIE] PRIMARY KEY CLUSTERED ([id_skierowania])
)
ON [PRIMARY]
GO

CREATE INDEX [dostarcza_fk]
  ON [dbo].[skierowanie] ([pesel_pacjent])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [skierowanie_pk]
  ON [dbo].[skierowanie] ([id_skierowania])
  ON [PRIMARY]
GO

CREATE INDEX [umozliwia_fk]
  ON [dbo].[skierowanie] ([id_pobytu])
  ON [PRIMARY]
GO

CREATE INDEX [wystawia_fk]
  ON [dbo].[skierowanie] ([id_lekarza])
  ON [PRIMARY]
GO