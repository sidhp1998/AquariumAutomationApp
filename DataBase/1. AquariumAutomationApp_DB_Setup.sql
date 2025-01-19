-- 1. Terminate all active connections to the database
USE master;
GO
ALTER DATABASE AquariumAutomationApp SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- 2. Drop the database
DROP DATABASE AquariumAutomationApp;
GO

-- 3. Create the Database
CREATE DATABASE AquariumAutomationApp;
GO

-- 4. Use the Database
USE AquariumAutomationApp;
GO

-- 5. Create Table UserTypeMaster

CREATE TABLE [dbo].[UserTypeMaster](
	[UserTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserTypeName] [varchar](25) NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- 6. Create Table UserMaster

CREATE TABLE [dbo].[UserMaster](
	[UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserFirstName] [varchar](50) NOT NULL,
	[UserLastName] [varchar](50) NULL,
	[UserEmail] [varchar](255) NOT NULL,
	[UserPhoneNumber] [varchar](20) NULL,
	[UserTypeId] [bigint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserMaster]  WITH CHECK ADD  CONSTRAINT [fk_UserMaster_UserTypeId_ref_UserTypeMaster_UserTypeId] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserTypeMaster] ([UserTypeId])
GO

ALTER TABLE [dbo].[UserMaster] CHECK CONSTRAINT [fk_UserMaster_UserTypeId_ref_UserTypeMaster_UserTypeId]
GO


-- 7. Create Table AccountMaster


CREATE TABLE [dbo].[AccountMaster](
	[AccountId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[PasswordHash] [varbinary](max) NOT NULL,
	[PasswordSalt] [varbinary](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[AccountMaster]  WITH CHECK ADD  CONSTRAINT [fk_AccountMaster_UserId_ref_UserMaster_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO

ALTER TABLE [dbo].[AccountMaster] CHECK CONSTRAINT [fk_AccountMaster_UserId_ref_UserMaster_UserId]
GO


-- 8. Create Table AquariumMaster

CREATE TABLE [dbo].[AquariumMaster](
	[AquariumId] [bigint] IDENTITY(1,1) NOT NULL,
	[AquariumName] [varchar](255) NOT NULL,
	[AquariumDescription] [varchar](255) NULL,
	[UserId] [bigint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Comments] [varchar](255) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AquariumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AquariumMaster]  WITH CHECK ADD  CONSTRAINT [fk_AquariumMaster_UserId_ref_UserMaster_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO

ALTER TABLE [dbo].[AquariumMaster] CHECK CONSTRAINT [fk_AquariumMaster_UserId_ref_UserMaster_UserId]
GO


-- 9. Create Table AquariumFixedProperty

CREATE TABLE [dbo].[AquariumFixedProperty](
	[AquariumFixedPropertyId] [bigint] IDENTITY(1,1) NOT NULL,
	[AquariumId] [bigint] NOT NULL,
	[Comments] [varchar](255) NULL,
	[Length] [int] NOT NULL,
	[Height] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AquariumFixedPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AquariumFixedProperty]  WITH CHECK ADD  CONSTRAINT [fk_AquariumFixedProperty_AquariumId_ref_AquariumMaster_AquariumId] FOREIGN KEY([AquariumId])
REFERENCES [dbo].[AquariumMaster] ([AquariumId])
GO

ALTER TABLE [dbo].[AquariumFixedProperty] CHECK CONSTRAINT [fk_AquariumFixedProperty_AquariumId_ref_AquariumMaster_AquariumId]
GO
-- _______ End Table AquariumFixedProperty __________

-- 10. Create Table AquariumVariableProperty

CREATE TABLE [dbo].[AquariumVariableProperty](
	[AquariumVariablePropertyId] [bigint] IDENTITY(1,1) NOT NULL,
	[AquariumId] [bigint] NOT NULL,
	[PH] [decimal](18, 0) NOT NULL,
	[Ammonia] [decimal](18, 0) NOT NULL,
	[Nitrite] [decimal](18, 0) NOT NULL,
	[Nitrate] [decimal](18, 0) NOT NULL,
	[Comments] [varchar](255) NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AquariumVariablePropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AquariumVariableProperty]  WITH CHECK ADD  CONSTRAINT [fk_AquariumVariableProperty_AquariumVariablePropertyId_ref_AquariumMaster_AquariumId] FOREIGN KEY([AquariumId])
REFERENCES [dbo].[AquariumMaster] ([AquariumId])
GO

ALTER TABLE [dbo].[AquariumVariableProperty] CHECK CONSTRAINT [fk_AquariumVariableProperty_AquariumVariablePropertyId_ref_AquariumMaster_AquariumId]
GO

-- ______________ End Table AquariumVariableProperty _____________________________

-- 11. Create Table AgentMaster
CREATE TABLE [dbo].[AgentMaster](
	[AgentId] [bigint] IDENTITY(1,1) NOT NULL,
	[AquariumId] [bigint] NOT NULL,
	[AgentName] [varchar](255) NOT NULL,
	[AgentDescription] [bigint] NULL,
	[AgentUserId] [bigint] NOT NULL,
	[AgentWifiMacAddress] [varchar](255) NOT NULL,
	[AgentBluetoothMacAddress] [varchar](255) NULL,
	[AgentIpAddress] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AgentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AgentMaster]  WITH CHECK ADD  CONSTRAINT [fk_AgentMaster_AgentUserId_ref_UserMaster_UserId] FOREIGN KEY([AgentUserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO

ALTER TABLE [dbo].[AgentMaster] CHECK CONSTRAINT [fk_AgentMaster_AgentUserId_ref_UserMaster_UserId]
GO

ALTER TABLE [dbo].[AgentMaster]  WITH CHECK ADD  CONSTRAINT [fk_AgentMaster_AquariumId_ref_AquariumMaster_AquariumId] FOREIGN KEY([AquariumId])
REFERENCES [dbo].[AquariumMaster] ([AquariumId])
GO

ALTER TABLE [dbo].[AgentMaster] CHECK CONSTRAINT [fk_AgentMaster_AquariumId_ref_AquariumMaster_AquariumId]
GO

-- ______________ End Table AgentMaster _____________________________

-- 12. Create Table DeviceTypeMaster 
CREATE TABLE [dbo].[DeviceTypeMaster](
	[DeviceTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[DeviceTypeName] [varchar](255) NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeviceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- ______________ End Table DeviceTypeMaster _____________________________

CREATE TABLE [dbo].[DeviceMaster](
	[DeviceId] [bigint] IDENTITY(1,1) NOT NULL,
	[AgentId] [bigint] NOT NULL,
	[DeviceName] [varchar](255) NOT NULL,
	[DeviceDescription] [varchar](255) NULL,
	[DeviceTypeId] [bigint] NOT NULL,
	[IsExternalDevice] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DeviceMaster]  WITH CHECK ADD  CONSTRAINT [fk_DeviceMaster_AgentId_ref_AgentMaster_AgentId] FOREIGN KEY([AgentId])
REFERENCES [dbo].[AgentMaster] ([AgentId])
GO

ALTER TABLE [dbo].[DeviceMaster] CHECK CONSTRAINT [fk_DeviceMaster_AgentId_ref_AgentMaster_AgentId]
GO

ALTER TABLE [dbo].[DeviceMaster]  WITH CHECK ADD  CONSTRAINT [fk_DeviceMaster_DeviceTypeId_ref_DeviceTypeMaster_DeviceTypeId] FOREIGN KEY([DeviceTypeId])
REFERENCES [dbo].[DeviceTypeMaster] ([DeviceTypeId])
GO

ALTER TABLE [dbo].[DeviceMaster] CHECK CONSTRAINT [fk_DeviceMaster_DeviceTypeId_ref_DeviceTypeMaster_DeviceTypeId]
GO

-- ______________ End Table DeviceMaster _____________________________

-- 14. Create table JobMaster

CREATE TABLE [dbo].[JobMaster](
	[JobId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobName] [varchar](255) NOT NULL,
	[JobDescription] [varchar](255) NULL,
	[DeviceId] [bigint] NOT NULL,
	[JobType] [varchar](255) NOT NULL,
	[Period] [bigint] NULL,
	[IsActive] [bigint] NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[JobMaster]  WITH CHECK ADD  CONSTRAINT [fk_JobMasrer_DeviceId_ref_DeviceMaster_DeviceId] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[DeviceMaster] ([DeviceId])
GO

ALTER TABLE [dbo].[JobMaster] CHECK CONSTRAINT [fk_JobMasrer_DeviceId_ref_DeviceMaster_DeviceId]
GO


-- ______________ End Table JobMaster _____________________________


-- 15. Create table  JobStatusMaster

CREATE TABLE [dbo].[JobStatusMaster](
	[JobStatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobStatus] [varchar](255) NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ______________ End Table JobStatusMaster _____________________________



CREATE TABLE [dbo].[JobTransaction](
	[JobTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[StatusId] [bigint] NOT NULL,
	[IsActive] [bigint] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CompletedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[JobTransaction]  WITH CHECK ADD  CONSTRAINT [fk_JobTransaction_JobId_JobMaster_JobId] FOREIGN KEY([JobId])
REFERENCES [dbo].[JobMaster] ([JobId])
GO

ALTER TABLE [dbo].[JobTransaction] CHECK CONSTRAINT [fk_JobTransaction_JobId_JobMaster_JobId]
GO

ALTER TABLE [dbo].[JobTransaction]  WITH CHECK ADD  CONSTRAINT [fk_JobTransaction_StatusId_JobStatusMaster_JobStatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[JobStatusMaster] ([JobStatusId])
GO

ALTER TABLE [dbo].[JobTransaction] CHECK CONSTRAINT [fk_JobTransaction_StatusId_JobStatusMaster_JobStatusId]
GO

ALTER TABLE [dbo].[JobTransaction]  WITH CHECK ADD  CONSTRAINT [fk_JobTransaction_UserId_UserMaster_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO

ALTER TABLE [dbo].[JobTransaction] CHECK CONSTRAINT [fk_JobTransaction_UserId_UserMaster_UserId]
GO

-- ______________ End Table JobTransaction _____________________________



-- -- 17. Create table TemperatureHistoryTransaction


CREATE TABLE [dbo].[TemperatureHistoryTransaction](
	[TemperatureHistoryTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobTransactionId] [bigint] NOT NULL,
	[AquariumId] [bigint] NOT NULL,
	[TemperatureValue] [decimal](8, 2) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TemperatureHistoryTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TemperatureHistoryTransaction]  WITH CHECK ADD  CONSTRAINT [fk_TemperatureHistoryTransaction_AquariumId_AquariumMaster_AquariumId] FOREIGN KEY([AquariumId])
REFERENCES [dbo].[AquariumMaster] ([AquariumId])
GO

ALTER TABLE [dbo].[TemperatureHistoryTransaction] CHECK CONSTRAINT [fk_TemperatureHistoryTransaction_AquariumId_AquariumMaster_AquariumId]
GO

ALTER TABLE [dbo].[TemperatureHistoryTransaction]  WITH CHECK ADD  CONSTRAINT [fk_TemperatureHistoryTransaction_JobTransactionId_JobTransaction_JobTransactionId] FOREIGN KEY([JobTransactionId])
REFERENCES [dbo].[JobTransaction] ([JobTransactionId])
GO

ALTER TABLE [dbo].[TemperatureHistoryTransaction] CHECK CONSTRAINT [fk_TemperatureHistoryTransaction_JobTransactionId_JobTransaction_JobTransactionId]
GO


