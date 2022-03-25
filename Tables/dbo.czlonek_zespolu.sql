CREATE TABLE [dbo].[czlonek_zespolu] (
  [id_zespolu] [char](7) NOT NULL,
  [id_dyzur] [char](7) NOT NULL,
  [data] [date] NOT NULL,
  [zmiana] [char](5) NOT NULL,
  CONSTRAINT [PK_CZLONEK_ZESPOLU] PRIMARY KEY CLUSTERED ([id_zespolu], [id_dyzur]),
  CONSTRAINT [CKC_ZMIANA_CZLONEK_] CHECK ([zmiana]='noc' OR [zmiana]='dzien')
)
ON [PRIMARY]
GO

CREATE INDEX [czlonek_zespolu_pk]
  ON [dbo].[czlonek_zespolu] ([id_dyzur])
  ON [PRIMARY]
GO

CREATE INDEX [czlonek_zespolu2_fk]
  ON [dbo].[czlonek_zespolu] ([id_zespolu])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[czlonek_zespolu]
  ADD CONSTRAINT [członek_zespołu] FOREIGN KEY ([id_dyzur]) REFERENCES [dbo].[dyzur] ([id_dyzur]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[czlonek_zespolu]
  ADD CONSTRAINT [członek_zespołu2] FOREIGN KEY ([id_zespolu]) REFERENCES [dbo].[zespol_operacyjny] ([id_zespolu]) ON DELETE CASCADE ON UPDATE CASCADE
GO