CREATE TABLE [dbo].[upowaznia] (
  [id_oswiadczenia] [char](7) NOT NULL,
  [id_upowaznionej] [char](7) NOT NULL,
  CONSTRAINT [PK_UPOWAZNIA] PRIMARY KEY CLUSTERED ([id_oswiadczenia], [id_upowaznionej])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [upowaznia_pk]
  ON [dbo].[upowaznia] ([id_oswiadczenia], [id_upowaznionej])
  ON [PRIMARY]
GO

CREATE INDEX [upowaznia2_fk]
  ON [dbo].[upowaznia] ([id_upowaznionej])
  ON [PRIMARY]
GO