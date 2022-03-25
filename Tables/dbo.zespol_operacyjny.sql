CREATE TABLE [dbo].[zespol_operacyjny] (
  [id_zespolu] [char](7) NOT NULL,
  [nr_sali] [numeric](3) NOT NULL,
  [id_dyzur] [char](7) NULL,
  CONSTRAINT [PK_ZESPOL_OPERACYJNY] PRIMARY KEY CLUSTERED ([id_zespolu]),
  CONSTRAINT [CKC_NR_SALI_ZESPOL_O] CHECK ([nr_sali]>=(1) AND [nr_sali]<=(999))
)
ON [PRIMARY]
GO

CREATE INDEX [operator_fk]
  ON [dbo].[zespol_operacyjny] ([id_dyzur])
  ON [PRIMARY]
GO

CREATE INDEX [sala_operacyjna_fk]
  ON [dbo].[zespol_operacyjny] ([nr_sali])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [zespol_operacyjny_pk]
  ON [dbo].[zespol_operacyjny] ([id_zespolu])
  ON [PRIMARY]
GO