CREATE TABLE [dbo].[oddzial] (
  [nr_oddzialu] [numeric](2) NOT NULL,
  [nazwa_oddzialu] [char](100) NOT NULL,
  [nr_pietra] [numeric](1) NOT NULL,
  [pawilon] [char](1) NOT NULL,
  [nr_telefonu] [char](9) NOT NULL,
  [g_dni_powszednie] [char](11) NULL,
  [g_swieta] [char](11) NULL,
  CONSTRAINT [PK_ODDZIAL] PRIMARY KEY CLUSTERED ([nr_oddzialu]),
  CONSTRAINT [CKC_NR_ODDZIALU_ODDZIAL] CHECK ([nr_oddzialu]>=(1) AND [nr_oddzialu]<=(999)),
  CONSTRAINT [CKC_NR_PIETRA_ODDZIAL] CHECK ([nr_pietra]>=(0) AND [nr_pietra]<=(3)),
  CONSTRAINT [CKC_PAWILON_ODDZIAL] CHECK ([pawilon]=upper([pawilon]))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [oddzial_pk]
  ON [dbo].[oddzial] ([nr_oddzialu])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [uidxn_oddzial]
  ON [dbo].[oddzial] ([nazwa_oddzialu])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [uidxp_oddzial]
  ON [dbo].[oddzial] ([nr_pietra], [pawilon])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [uidxt_oddzial]
  ON [dbo].[oddzial] ([nr_telefonu])
  ON [PRIMARY]
GO